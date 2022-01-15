mod dtos;
mod models;

pub use dtos::*;
pub use models::*;

use crate::error::Result;
use crate::storage::Database;
use chrono::DateTime;
use chrono::Utc;

pub async fn get_all_ingredients<D>(db: &D) -> Result<Vec<Ingredient>>
where
    D: Database,
{
    db.fetch_all_ingredients().await
}

pub fn extract_calorie_trend(ingredients: Vec<Ingredient>) -> Trend {
    let mut points = Vec::with_capacity(ingredients.len());
    let mut index = 0.0;
    for ingredient in ingredients {
        points.push(Point {
            x: index,
            y: ingredient.calories as f64,
            label: ingredient.name,
        });
        index += 1.0;
    }

    let trend_line = linear_regression(&points);

    Trend {
        name: "calories".to_string(),
        points,
        line: trend_line,
    }
}

pub async fn get_daily_macro_trends_since_date<D>(db: &D, date: DateTime<Utc>) -> Result<Vec<Trend>>
where
    D: Database,
{
    let summaries = db.fetch_daily_summaries(date).await?;

    if summaries.len() < 1 {
        return Ok(Default::default());
    }

    let mut trends = Vec::with_capacity(3);
    trends.push(extract_carb_trend(&summaries));
    trends.push(extract_fat_trend(&summaries));
    trends.push(extract_protein_trend(&summaries));

    Ok(trends)
}

fn extract_carb_trend(summaries: &Vec<DailyMacroSummary>) -> Trend {
    let first_date: DateTime<Utc> = summaries[0].date;
    let carb_points = summaries
        .iter()
        .map(|dms| Point {
            x: (dms.date - first_date).num_days() as f64,
            y: dms.carb_grams as f64,
            label: dms.date.format("%Y-%m-%d").to_string(),
        })
        .collect();
    let carb_trend = linear_regression(&carb_points);

    Trend {
        name: "carb_grams".to_string(),
        points: carb_points,
        line: carb_trend,
    }
}

fn extract_fat_trend(summaries: &Vec<DailyMacroSummary>) -> Trend {
    let first_date: DateTime<Utc> = summaries[0].date;
    let fat_points = summaries
        .iter()
        .map(|dms| Point {
            x: (dms.date - first_date).num_days() as f64,
            y: dms.fat_grams as f64,
            label: dms.date.format("%Y-%m-%d").to_string(),
        })
        .collect();
    let fat_trend = linear_regression(&fat_points);

    Trend {
        name: "fat_grams".to_string(),
        points: fat_points,
        line: fat_trend,
    }
}

fn extract_protein_trend(summaries: &Vec<DailyMacroSummary>) -> Trend {
    let first_date: DateTime<Utc> = summaries[0].date;
    let protein_points = summaries
        .iter()
        .map(|dms| Point {
            x: (dms.date - first_date).num_days() as f64,
            y: dms.protein_grams as f64,
            label: dms.date.format("%Y-%m-%d").to_string(),
        })
        .collect();
    let protein_trend = linear_regression(&protein_points);

    Trend {
        name: "protein_grams".to_string(),
        points: protein_points,
        line: protein_trend,
    }
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
            1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65, 1.68, 1.70, 1.73, 1.75, 1.78, 1.80,
            1.83,
        ];
        let masses = vec![
            52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29, 63.11, 64.47, 66.28, 68.10,
            69.92, 72.19, 74.46,
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
