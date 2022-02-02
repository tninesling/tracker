use chrono::{DateTime, Utc};
use sqlx::FromRow;

#[derive(FromRow)]
pub struct DailyMacroSummary {
    pub day: DateTime<Utc>,
    pub carb_grams: f64,
    pub fat_grams: f64,
    pub protein_grams: f64,
}
