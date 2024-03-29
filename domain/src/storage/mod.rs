mod postgres;
use chrono::{DateTime, Utc};
pub use postgres::*;
use uuid::Uuid;

use crate::error::Result;
use crate::meals::{CreateIngredientRequest, CreateMealRequest, Ingredient, Meal};
use crate::trends::DailyMacroSummary;
use async_trait::async_trait;

#[async_trait]
pub trait Database {
    async fn create_ingredient(&self, req: &CreateIngredientRequest) -> Result<Uuid>;

    async fn get_ingredients(&self, offset: &i32, limit: &u32) -> Result<Vec<Ingredient>>;

    async fn get_meal_ingredients(&self, meals_id: Uuid) -> Result<Vec<Ingredient>>;

    async fn create_meal(&self, req: &CreateMealRequest) -> Result<Uuid>;

    async fn get_meals(&self, after: &DateTime<Utc>, limit: &u32) -> Result<Vec<Meal>>;

    async fn delete_meal(&self, meals_id: Uuid) -> Result<()>;

    async fn get_daily_summaries(&self, since: DateTime<Utc>) -> Result<Vec<DailyMacroSummary>>;
}
