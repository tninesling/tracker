use crate::error::Error;
use crate::error::Result;
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
    pub sugar_grams: f64,
    pub sodium_milligrams: f64,
}

impl CreateIngredientRequest {
    pub fn validate(&self) -> Result<&CreateIngredientRequest> {
        if self.amount_grams <= 0.0 {
            Err(Error::BadRequest("Amount must be greater than zero.".to_string()))
        } else {
            Ok(self)
        }
    }
}

#[derive(Debug, FromRow, Deserialize, Serialize, JsonSchema, TypedBuilder)]
#[serde(rename_all = "camelCase")]
pub struct Ingredient {
    pub id: Uuid,
    pub name: String,
    pub amount_grams: f64,
    pub calories: f64,
    pub carb_grams: f64,
    pub fat_grams: f64,
    pub protein_grams: f64,
    pub sugar_grams: f64,
    pub sodium_milligrams: f64,
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
