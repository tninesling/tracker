use chrono::{DateTime, Utc};
use sqlx::FromRow;
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

#[derive(FromRow)]
pub struct DailyMacroSummary {
    pub date: DateTime<Utc>,
    pub carb_grams: f32,
    pub fat_grams: f32,
    pub protein_grams: f32,
}
