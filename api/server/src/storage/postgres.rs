use crate::error::Error;
use crate::error::Result;
use crate::storage::Database;
use crate::trends::DailyMacroSummary;
use crate::trends::Ingredient;
use async_trait::async_trait;
use sqlx::PgPool;

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
    async fn fetch_all_ingredients(&self) -> Result<Vec<crate::trends::Ingredient>> {
        sqlx::query_as::<_, Ingredient>(
            r#"
            SELECT id, name, calories, carb_grams, fat_grams, protein_grams
            FROM ingredients
        "#,
        )
        .fetch_all(self.connection_pool)
        .await
        .map_err(Error::DBError)
    }

    async fn fetch_daily_summaries(
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
