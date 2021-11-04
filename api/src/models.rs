use chrono::prelude::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use uuid::Uuid;

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
