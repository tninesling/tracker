mod postgres;
use chrono::{DateTime, Utc};
pub use postgres::*;
use uuid::Uuid;

use crate::error::Result;
use crate::meals::{CreateIngredientRequest, Ingredient};
use crate::trends::DailyMacroSummary;
use async_trait::async_trait;

#[async_trait]
pub trait Database {
    async fn create_ingredient(&self, req: &CreateIngredientRequest) -> Result<Uuid>;

    async fn get_ingredients(&self, offset: &i32, limit: &u32) -> Result<Vec<Ingredient>>;

    async fn get_daily_summaries(&self, since: DateTime<Utc>) -> Result<Vec<DailyMacroSummary>>;
}
