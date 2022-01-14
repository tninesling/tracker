use chrono::DateTime;
use chrono::Utc;
use schemars::JsonSchema;
use serde::Deserialize;
use serde::Serialize;

#[derive(Default, Serialize, JsonSchema)]
#[serde(rename_all = "camelCase")]
pub struct Trend {
  pub points: Vec<Point>,
  pub line: Line,
}

#[derive(Serialize, JsonSchema)]
pub struct Point {
  pub x: f64,
  pub y: f64,
  pub label: String,
}

#[derive(Default, Serialize, JsonSchema)]
pub struct Line {
  pub slope: f64,
  pub intercept: f64,
}

#[derive(Deserialize, JsonSchema)]
pub struct MacroTrendsQuery {
  pub date: DateTime<Utc>,
}