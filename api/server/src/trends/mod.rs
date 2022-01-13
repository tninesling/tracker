mod dtos;
mod models;

use std::collections::HashMap;

use chrono::Datelike;
pub use dtos::*;
pub use models::*;

use chrono::DateTime;
use chrono::Utc;
use sqlx::PgPool;
use sqlx::postgres::PgRow;
use sqlx::Row;

pub async fn get_all_ingredients(db_pool: &PgPool) -> Result<Vec<Ingredient>, sqlx::Error> {
  sqlx::query(r#"
        SELECT id, name, calories, carb_grams, fat_grams, protein_grams
        FROM ingredients
    "#)
    .map(|row: PgRow| {
        Ingredient {
            id: row.get(0),
            name: row.get(1),
            calories: row.get(2),
            carb_grams: row.get(3),
            fat_grams: row.get(4),
            protein_grams: row.get(5),
        }
    })
    .fetch_all(db_pool)
    .await
}

pub async fn get_daily_macro_trends_since_date(db_pool: &PgPool, date: DateTime<Utc>) -> Result<HashMap<String, Trend>, sqlx::Error> {
  let rows: Vec<PgRow> = sqlx::query(r#"
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
  "#)
  .bind(date)
  .fetch_all(db_pool)
  .await?;

  if rows.len() < 1 {
    return Ok(HashMap::new());
  }

  let first_date: DateTime<Utc> = rows[0].get(0);

  let carb_points = rows.iter().map(|row| {
    let date: DateTime<Utc> = row.get(0);  
    let carb_grams: f64 = row.get(1);
    let days_since_first_date = (date - first_date).num_days() as f64;
    let label = format!("{}-{}-{}", date.year(), date.month(), date.day());

    Point { x: days_since_first_date, y: carb_grams, label }
  }).collect();
  let carb_trend = linear_regression(&carb_points);

  let fat_points = rows.iter().map(|row| {
    let date: DateTime<Utc> = row.get(0);  
    let fat_grams: f64 = row.get(2);
    let days_since_first_date = (date - first_date).num_days() as f64;
    let label = format!("{}-{}-{}", date.year(), date.month(), date.day());

    Point { x: days_since_first_date, y: fat_grams, label }
  }).collect();
  let fat_trend = linear_regression(&fat_points);

  let protein_points = rows.iter().map(|row| {
    let date: DateTime<Utc> = row.get(0);  
    let protein_grams: f64 = row.get(3);
    let days_since_first_date = (date - first_date).num_days() as f64;
    let label = format!("{}-{}-{}", date.year(), date.month(), date.day());

    Point { x: days_since_first_date, y: protein_grams, label }
  }).collect();
  let protein_trend = linear_regression(&protein_points);

  let mut trend_map = HashMap::with_capacity(3);
  trend_map.insert("carbs".to_string(), Trend {
    points: carb_points,
    line: carb_trend,
  });
  trend_map.insert("fat".to_string(), Trend {
    points: fat_points,
    line: fat_trend,
  });
  trend_map.insert("protein".to_string(), Trend {
    points: protein_points,
    line: protein_trend,
  });

  Ok(trend_map)
}

pub fn linear_regression(points: &Vec<Point>) -> Line {
  let sum_x = points.iter().fold(0.0, |acc, p| acc + p.x);
  let sum_y = points.iter().fold(0.0, |acc, p| acc + p.y);
  let sum_xx = points.iter().fold(0.0, |acc, p| acc + p.x.powf(2.0));
  // let sum_yy = points.iter().fold(0.0, |acc, p| acc + p.y.powf(2.0));
  let sum_xy = points.iter().fold(0.0, |acc, p| acc + p.x * p.y);
  let n = points.len() as f64;

  let slope = (n * sum_xy - sum_x * sum_y) / (n * sum_xx - sum_x.powf(2.0));
  let intercept = sum_y / n - slope / n * sum_x;

  Line { slope, intercept }
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn basic_linear_regression() {
    // Example from https://en.wikipedia.org/wiki/Simple_linear_regression (Numerical example section)
    let heights = vec![
      1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65, 1.68, 1.70, 1.73, 1.75, 1.78, 1.80, 1.83,
    ];
    let masses = vec![
      52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29, 63.11, 64.47, 66.28, 68.10, 69.92,
      72.19, 74.46,
    ];
    let points = heights
      .iter()
      .zip(masses)
      .map(|(h, m)| Point {
        x: *h,
        y: m,
        label: String::new(),
      })
      .collect();

    let regression_line = linear_regression(&points);

    let allowed_error = 0.01;
    let expected_slope = 61.272;
    let expected_intercept = -39.062;
    let slope_error = (regression_line.slope - expected_slope).abs();
    let intercept_error = (regression_line.intercept - expected_intercept).abs();
    assert!(slope_error < allowed_error);
    assert!(intercept_error < allowed_error);
  }
}
