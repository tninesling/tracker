use crate::error::Error;
use crate::error::Result;
use crate::meals::CreateIngredientRequest;
use crate::meals::CreateMealRequest;
use crate::meals::Ingredient;
use crate::meals::Meal;
use crate::storage::Database;
use crate::trends::DailyMacroSummary;
use async_trait::async_trait;
use chrono::DateTime;
use chrono::Utc;
use sqlx::postgres::PgRow;
use sqlx::PgPool;
use sqlx::Row;
use uuid::Uuid;

pub struct Postgres<'a> {
    connection_pool: &'a PgPool,
}

impl<'a> Postgres<'a> {
    pub fn new(connection_pool: &PgPool) -> Postgres {
        Postgres { connection_pool }
    }
}

#[async_trait]
impl Database for Postgres<'_> {
    async fn create_ingredient(&self, req: &CreateIngredientRequest) -> Result<Uuid> {
        let id = sqlx::query_scalar(
            r#"
            INSERT INTO ingredients
                (name, amount_grams, calories, carb_grams, fat_grams, protein_grams)
            VALUES
                ($1, $2, $3, $4, $5, $6)
            RETURNING id
        "#,
        )
        .bind(req.name.to_string())
        .bind(req.amount_grams)
        .bind(req.calories)
        .bind(req.carb_grams)
        .bind(req.fat_grams)
        .bind(req.protein_grams)
        .fetch_one(self.connection_pool)
        .await
        .map_err(Error::DBError)?;

        Ok(id)
    }

    async fn get_ingredients(&self, offset: &i32, limit: &u32) -> Result<Vec<Ingredient>> {
        sqlx::query_as::<_, Ingredient>(
            r#"
            SELECT id, name, amount_grams, calories, carb_grams, fat_grams, protein_grams
            FROM ingredients
            OFFSET $1
            LIMIT $2
        "#,
        )
        .bind(offset)
        .bind(limit)
        .fetch_all(self.connection_pool)
        .await
        .map_err(Error::DBError)
    }

    async fn get_meal_ingredients(&self, meals_id: Uuid) -> Result<Vec<Ingredient>> {
        sqlx::query_as::<_, Ingredient>(
            r#"
            SELECT
                i.id,
                i.name,
                mi.amount_grams,
                i.calories / i.amount_grams * mi.amount_grams as calories,
                i.carb_grams / i.amount_grams * mi.amount_grams as carb_grams,
                i.fat_grams / i.amount_grams * mi.amount_grams as fat_grams,
                i.protein_grams / i.amount_grams * mi.amount_grams as protein_grams
            FROM ingredients i
            JOIN meals_ingredients mi
            ON i.id = mi.ingredients_id
            WHERE mi.meals_id = $1
        "#,
        )
        .bind(meals_id)
        .fetch_all(self.connection_pool)
        .await
        .map_err(Error::DBError)
    }

    async fn create_meal(&self, req: &CreateMealRequest) -> Result<Uuid> {
        let id: Uuid = sqlx::query_scalar(
            r#"
                INSERT INTO meals
                    (date)
                VALUES
                    ($1)
                RETURNING id
            "#,
        )
        .bind(req.date)
        .fetch_one(self.connection_pool)
        .await?;

        for (ingredients_id, amount_grams) in req.ingredient_amounts.iter() {
            sqlx::query(
                r#"
                INSERT INTO meals_ingredients
                    (meals_id, ingredients_id, amount_grams)
                VALUES
                    ($1, $2, $3)
            "#,
            )
            .bind(id)
            .bind(ingredients_id)
            .bind(amount_grams)
            .fetch_all(self.connection_pool)
            .await?;
        }

        Ok(id)
    }

    async fn get_meals(&self, after: &DateTime<Utc>, limit: &u32) -> Result<Vec<Meal>> {
        let mut meals = Vec::with_capacity(*limit as usize);
        let meal_rows: Vec<PgRow> = sqlx::query(
            r#"
            SELECT id, date
            FROM meals
            WHERE date > $1
            LIMIT $2
        "#,
        )
        .bind(after)
        .bind(limit)
        .fetch_all(self.connection_pool)
        .await?;

        for row in meal_rows {
            let id = row.get(0);
            let date = row.get(1);
            let ingredients = self.get_meal_ingredients(id).await?;

            meals.push(
                Meal::builder()
                    .id(id)
                    .date(date)
                    .ingredients(ingredients)
                    .build(),
            );
        }

        Ok(meals)
    }

    async fn delete_meal(&self, meals_id: Uuid) -> Result<()> {
        sqlx::query(
            r#"
            DELETE FROM meals WHERE id = $1
        "#,
        )
        .bind(meals_id)
        .fetch_all(self.connection_pool)
        .await?;

        Ok(())
    }

    async fn get_daily_summaries(
        &self,
        since: chrono::DateTime<chrono::Utc>,
    ) -> Result<Vec<DailyMacroSummary>> {
        sqlx::query_as::<_, DailyMacroSummary>(
            r#"
        WITH ingredients_eaten AS (
          SELECT
            DATE_TRUNC('day', m.date) AS day,
            i.carb_grams AS carb_grams,
            i.fat_grams AS fat_grams,
            i.protein_grams AS protein_grams
          FROM meals m
            JOIN meals_ingredients mi
            ON m.id = mi.meals_id
            JOIN ingredients i
            ON mi.ingredients_id = i.id
          WHERE m.date > $1
        )
        SELECT
          day,
          SUM(carb_grams) AS carb_grams,
          SUM(fat_grams) AS fat_grams,
          SUM(protein_grams) AS protein_grams
        FROM ingredients_eaten
        GROUP BY day
        ORDER BY day ASC
      "#,
        )
        .bind(since)
        .fetch_all(self.connection_pool)
        .await
        .map_err(Error::DBError)
    }
}
