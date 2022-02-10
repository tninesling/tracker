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

    async fn create_meal(&self, req: &CreateMealRequest) -> Result<Uuid>;

    async fn get_meals(&self, offset: &i32, limit: &u32) -> Result<Vec<Meal>>;

    async fn get_daily_summaries(&self, since: DateTime<Utc>) -> Result<Vec<DailyMacroSummary>>;
}
