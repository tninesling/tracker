use anyhow::Result;
use chrono::prelude::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, SqlitePool, Transaction};
use uuid::Uuid;

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ExerciseRequest {
  pub name: String,
  pub reps: i32,
  pub sets: i32,
  pub weight_kg: f64,
}

#[derive(Serialize, FromRow)]
pub struct Exercise {
  pub id: Uuid,
  pub name: String,
  pub reps: i32,
  pub sets: i32,
  pub weight_kg: f64,
  pub workouts_id: Uuid,
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct WorkoutRequest {
  pub date: DateTime<Utc>,
  pub exercises: Vec<ExerciseRequest>,
}

#[derive(Serialize, FromRow)]
pub struct Workout {
  pub id: Uuid,
  pub date: DateTime<Utc>,
  pub exercises: Vec<Exercise>,
}

impl Exercise {
  pub async fn create<'a>(
    exercise_req: ExerciseRequest,
    workouts_id: Uuid,
    tx: &mut Transaction<'a, sqlx::Sqlite>,
  ) -> Result<Exercise> {
    let id = Uuid::new_v4();

    sqlx::query!(
      r#"
      INSERT INTO exercises (id, name, reps, sets, weight_kg, workouts_id)
      VALUES ($1, $2, $3, $4, $5, $6)
      "#,
      id,
      exercise_req.name,
      exercise_req.reps,
      exercise_req.sets,
      exercise_req.weight_kg,
      workouts_id
    )
    .execute(tx)
    .await?;

    Ok(Exercise {
      id,
      name: exercise_req.name,
      reps: exercise_req.reps,
      sets: exercise_req.sets,
      weight_kg: exercise_req.weight_kg,
      workouts_id,
    })
  }
}

impl Workout {
  pub async fn create(workout_req: WorkoutRequest, pool: &SqlitePool) -> Result<Workout> {
    let mut tx = pool.begin().await?;
    let mut workout = Workout {
      id: Uuid::new_v4(),
      date: workout_req.date,
      exercises: vec![],
    };

    sqlx::query!(
      r#"
      INSERT INTO workouts (id, date)
      VALUES ($1, $2)
      "#,
      workout.id,
      workout.date,
    )
    .execute(&mut tx)
    .await?;

    for exercise_req in workout_req.exercises {
      let exercise = Exercise::create(exercise_req, workout.id, &mut tx).await?;

      workout.exercises.push(exercise);
    }

    tx.commit().await?;

    Ok(workout)
  }
}
