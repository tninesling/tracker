use sqlx::FromRow;
use uuid::Uuid;

#[derive(FromRow)]
pub struct Ingredient {
  pub id: Uuid,
  pub name: String,
  pub calories: f32,
  pub carb_grams: f32,
  pub fat_grams: f32,
  pub protein_grams: f32,
}