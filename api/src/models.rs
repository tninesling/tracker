use chrono::prelude::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use uuid::Uuid;

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
    pub carbohydrates_mg: f64,
    pub fat_mg: f64,
    pub protein_mg: f64,
    #[serde(default)]
    pub saturated_fat_mg: f64,
    #[serde(default)]
    pub polyunsaturated_fat_mg: f64,
    #[serde(default)]
    pub monounsaturated_fat_mg: f64,
    #[serde(default)]
    pub trans_fat_mg: f64,
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
pub struct Recipe {
    #[serde(skip)]
    pub id: i64,
    #[serde(default = "Uuid::new_v4")]
    pub public_id: Uuid,
    pub date: DateTime<Utc>,
    pub ingredient_servings: HashMap<Uuid, f64>,
}
