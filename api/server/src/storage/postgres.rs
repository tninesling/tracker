use crate::error::Error;
use crate::error::Result;
use crate::meals::CreateIngredientRequest;
use crate::meals::Ingredient;
use crate::storage::Database;
use crate::trends::DailyMacroSummary;
use async_trait::async_trait;
use sqlx::PgPool;
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

    async fn get_all_ingredients(&self) -> Result<Vec<Ingredient>> {
        sqlx::query_as::<_, Ingredient>(
            r#"
            SELECT id, name, amount_grams, calories, carb_grams, fat_grams, protein_grams
            FROM ingredients
        "#,
        )
        .fetch_all(self.connection_pool)
        .await
        .map_err(Error::DBError)
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
