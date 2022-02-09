use std::collections::HashMap;
use chrono::DateTime;
use chrono::Utc;
use schemars::JsonSchema;
use serde::Deserialize;
use serde::Serialize;
use sqlx::FromRow;
use typed_builder::TypedBuilder;
use uuid::Uuid;

#[derive(Deserialize, Serialize, JsonSchema)]
#[serde(rename_all = "camelCase")]
pub struct CreateIngredientRequest {
    pub name: String,
    pub amount_grams: f32,
    pub calories: f32,
    pub carb_grams: f32,
    pub fat_grams: f32,
    pub protein_grams: f32,
}

#[derive(FromRow, Deserialize, Serialize, JsonSchema, TypedBuilder)]
#[serde(rename_all = "camelCase")]
pub struct Ingredient {
    pub id: Uuid,
    pub name: String,
    pub amount_grams: f32,
    pub calories: f32,
    pub carb_grams: f32,
    pub fat_grams: f32,
    pub protein_grams: f32,
}

#[derive(Deserialize, JsonSchema, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct CreateMealRequest {
    pub date: DateTime<Utc>,
    pub ingredient_amounts: HashMap<Uuid, f32>,
}

#[derive(Deserialize, JsonSchema, Serialize, TypedBuilder)]
#[serde(rename_all = "camelCase")]
pub struct Meal {
    pub id: Uuid,
    pub date: DateTime<Utc>,
    pub ingredient_amounts: HashMap<Uuid, f32>,
}