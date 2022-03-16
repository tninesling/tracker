use chrono::DateTime;
use chrono::Utc;
use schemars::JsonSchema;
use serde::Deserialize;
use serde::Serialize;
use sqlx::FromRow;
use std::collections::HashMap;
use typed_builder::TypedBuilder;
use uuid::Uuid;

#[derive(Deserialize, Serialize, JsonSchema)]
#[serde(rename_all = "camelCase")]
pub struct CreateIngredientRequest {
    pub name: String,
    pub amount_grams: f64,
    pub calories: f64,
    pub carb_grams: f64,
    pub fat_grams: f64,
    pub protein_grams: f64,
}

#[derive(FromRow, Deserialize, Serialize, JsonSchema, TypedBuilder)]
#[serde(rename_all = "camelCase")]
pub struct Ingredient {
    pub id: Uuid,
    pub name: String,
    pub amount_grams: f64,
    pub calories: f64,
    pub carb_grams: f64,
    pub fat_grams: f64,
    pub protein_grams: f64,
}

#[derive(Deserialize, JsonSchema, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CreateMealRequest {
    pub date: DateTime<Utc>,
    pub ingredient_amounts: HashMap<Uuid, f64>,
}

#[derive(Deserialize, JsonSchema, Serialize, TypedBuilder)]
#[serde(rename_all = "camelCase")]
pub struct Meal {
    pub id: Uuid,
    pub date: DateTime<Utc>,
    pub ingredients: Vec<Ingredient>,
}

impl Meal {
    pub fn calories(&self) -> f64 {
        self.ingredients.iter().fold(0.0, |acc, i| acc + i.calories)
    }

    pub fn carb_grams(&self) -> f64 {
        self.ingredients.iter().fold(0.0, |acc, i| acc + i.carb_grams)
    }

    pub fn fat_grams(&self) -> f64 {
        self.ingredients.iter().fold(0.0, |acc, i| acc + i.fat_grams)
    }

    pub fn protein_grams(&self) -> f64 {
        self.ingredients.iter().fold(0.0, |acc, i| acc + i.protein_grams)
    }
}

// TODO: Fold this into meal and ingredient models
pub struct NutritionFacts {
    pub amount_grams: f64,
    pub calories: f64,
    pub carb_grams: f64,
    pub fat_grams: f64,
    pub protein_grams: f64,
}
