mod postgres;
use chrono::{DateTime, Utc};
pub use postgres::*;

use crate::error::Result;
use crate::trends::DailyMacroSummary;
use crate::trends::Ingredient;
use async_trait::async_trait;

#[async_trait]
pub trait Database {
    async fn fetch_all_ingredients(&self) -> Result<Vec<Ingredient>>;

    async fn fetch_daily_summaries(&self, since: DateTime<Utc>) -> Result<Vec<DailyMacroSummary>>;
}
