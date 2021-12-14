use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct WorkoutSummary {
    pub date: DateTime<Utc>,
    pub total_weight_kg: f32,
}
