use chrono::{DateTime, Utc};
use sqlx::FromRow;

#[derive(FromRow)]
pub struct DailyMacroSummary {
    pub date: DateTime<Utc>,
    pub carb_grams: f32,
    pub fat_grams: f32,
    pub protein_grams: f32,
}
