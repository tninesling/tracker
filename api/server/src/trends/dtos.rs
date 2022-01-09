use schemars::JsonSchema;
use serde::Serialize;

#[derive(Serialize, JsonSchema)]
#[serde(rename_all = "camelCase")]
pub struct Trend {
  pub points: Vec<Point>,
  pub line: Line,
}

#[derive(Serialize, JsonSchema)]
pub struct Point {
  pub x: f32,
  pub y: f32,
  pub label: String,
}

#[derive(Serialize, JsonSchema)]
pub struct Line {
  pub slope: f32,
  pub intercept: f32,
}
