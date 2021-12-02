use chrono::prelude::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

use std::collections::HashMap;

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Exercise {
    #[serde(skip)]
    pub id: i64,
    #[serde(default = "Uuid::new_v4")]
    pub public_id: Uuid,
    pub name: String,
    pub reps: u8,
    pub sets: u8,
    pub weight_kg: f64,
    #[serde(skip)]
    pub workouts_id: i64,
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Workout {
    #[serde(skip)]
    pub id: i64,
    #[serde(default = "Uuid::new_v4")]
    pub public_id: Uuid,
    pub date: DateTime<Utc>,
    pub exercises: Vec<Exercise>,
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct WorkoutSummary {
    pub start_date: DateTime<Utc>,
    pub end_date: DateTime<Utc>,
    pub total_weight_kg: f64,
}

#[derive(Serialize, Deserialize)]
pub enum IngredientUnit {
    #[serde(rename = "mg")]
    Milligrams,
    #[serde(rename = "ml")]
    Milliliters,
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Ingredient {
    #[serde(skip)]
    pub id: i64,
    #[serde(default = "Uuid::new_v4")]
    pub public_id: Uuid,
    pub name: String,
    pub serving_size: f64,
    pub serving_unit: IngredientUnit,
    pub calories: f64,
    pub carbohydrates_g: f64,
    pub fat_g: f64,
    pub protein_g: f64,
    #[serde(default)]
    pub saturated_fat_g: f64,
    #[serde(default)]
    pub polyunsaturated_fat_g: f64,
    #[serde(default)]
    pub monounsaturated_fat_g: f64,
    #[serde(default)]
    pub trans_fat_g: f64,
    #[serde(default)]
    pub fiber_mg: f64,
    #[serde(default)]
    pub sugar_mg: f64,
    #[serde(default)]
    pub added_sugar_mg: f64,
    #[serde(default)]
    pub cholesterol_mg: f64,
    #[serde(default)]
    pub sodium_mg: f64,
    #[serde(default)]
    pub potassium_mg: f64,
    #[serde(default)]
    pub calcium_mg: f64,
    #[serde(default)]
    pub iron_mg: f64,
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Meal {
    #[serde(skip)]
    pub id: i64,
    #[serde(default = "Uuid::new_v4")]
    pub public_id: Uuid,
    pub date: DateTime<Utc>,
    pub ingredient_servings: HashMap<Uuid, f64>,
}

#[derive(Serialize)]
#[serde(rename_all = "camelCase")]
pub struct MealSummary {
    pub start_date: DateTime<Utc>,
    pub end_date: DateTime<Utc>,
    pub calories: f64,
    pub carbohydrates_g: f64,
    pub fat_g: f64,
    pub protein_g: f64,
}

impl MealSummary {
    pub fn new() -> MealSummary {
        MealSummary {
            start_date: Utc::now(),
            end_date: Utc::now(),
            calories: 0.0,
            carbohydrates_g: 0.0,
            fat_g: 0.0,
            protein_g: 0.0,
        }
    }
}

impl std::ops::Add<&MealSummary> for MealSummary {
    type Output = MealSummary;

    fn add(self, other: &MealSummary) -> MealSummary {
        MealSummary {
            start_date: Ord::min(self.start_date, other.start_date),
            end_date: Ord::max(self.end_date, other.end_date),
            calories: self.calories + other.calories,
            carbohydrates_g: self.carbohydrates_g + other.carbohydrates_g,
            fat_g: self.fat_g + other.fat_g,
            protein_g: self.protein_g + other.protein_g,
        }
    }
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct WeighIn {
    #[serde(skip)]
    pub id: i64,
    pub date: DateTime<Utc>,
    pub weight_lbs: f64,
}
