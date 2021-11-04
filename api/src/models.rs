use chrono::prelude::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct Workout {
    #[serde(skip)]
    pub id: i64,
    #[serde(default)]
    pub public_id: String,
    pub date: DateTime<Utc>,
    pub exercises: Vec<Exercise>,
}

#[derive(Serialize, Deserialize)]
pub struct Exercise {
    #[serde(skip)]
    pub id: i64,
    #[serde(default)]
    pub public_id: String,
    pub name: String,
    pub reps: u8,
    pub sets: u8,
    pub weight_kg: f64,
    #[serde(skip)]
    pub workouts_id: i64,
}
