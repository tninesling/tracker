use serde::Serialize;

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct Trend {
  pub points: Vec<Point>,
  pub line: Line,
}

#[derive(Serialize)]
pub struct Point {
  pub x: f32,
  pub y: f32,
  pub label: String,
}

#[derive(Serialize)]
pub struct Line {
  pub slope: f32,
  pub intercept: f32,
}
