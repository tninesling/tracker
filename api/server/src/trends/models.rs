use crate::error::{Error, Result};
use chrono::{DateTime, Utc};
use sqlx::FromRow;
use sqlx::PgPool;
use uuid::Uuid;

#[derive(FromRow)]
pub struct Ingredient {
    pub id: Uuid,
    pub name: String,
    pub calories: f32,
    pub carb_grams: f32,
    pub fat_grams: f32,
    pub protein_grams: f32,
}

impl Ingredient {
    pub async fn fetch_all(db_pool: &PgPool) -> Result<Vec<Ingredient>> {
        sqlx::query_as::<_, Ingredient>(
            r#"
            SELECT id, name, calories, carb_grams, fat_grams, protein_grams
            FROM ingredients
        "#,
        )
        .fetch_all(db_pool)
        .await
        .map_err(Error::DBError)
    }
}

#[derive(FromRow)]
pub struct DailyMacroSummary {
    pub date: DateTime<Utc>,
    pub carb_grams: f32,
    pub fat_grams: f32,
    pub protein_grams: f32,
}

impl DailyMacroSummary {
    pub async fn fetch_since_date(db_pool: &PgPool, date: DateTime<Utc>) -> Result<Vec<DailyMacroSummary>> {
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
        .bind(date)
        .fetch_all(db_pool)
        .await
        .map_err(Error::DBError)
    }
}