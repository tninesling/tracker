use chrono::DateTime;
use chrono::Utc;
use schemars::JsonSchema;
use serde::Deserialize;
use serde::Serialize;
use sqlx::FromRow;

#[derive(FromRow)]
pub struct DailyMacroSummary {
    pub day: DateTime<Utc>,
    pub carb_grams: f64,
    pub fat_grams: f64,
    pub protein_grams: f64,
    pub sugar_grams: f64,
    pub sodium_milligrams: f64,
}

#[derive(Debug, Default, Serialize, JsonSchema)]
#[serde(rename_all = "camelCase")]
pub struct Trend {
    pub name: String,
    pub points: Vec<Point>,
    pub line: Line,
}

#[derive(Debug, Serialize, JsonSchema)]
pub struct Point {
    pub x: f64,
    pub y: f64,
    pub label: String,
}

#[derive(Debug, Default, Serialize, JsonSchema)]
pub struct Line {
    pub slope: f64,
    pub intercept: f64,
}

#[derive(Deserialize, JsonSchema)]
pub struct MacroTrendsQuery {
    pub date: DateTime<Utc>,
}
