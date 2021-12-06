use anyhow::Result;
use chrono::prelude::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::{FromRow, SqlitePool, Transaction};
use std::collections::HashMap;
use uuid::Uuid;

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct ExerciseRequest {
  pub name: String,
  pub reps: i64,
  pub sets: i64,
  pub weight_kg: f32,
}

#[derive(Serialize, FromRow)]
pub struct Exercise {
  pub id: Uuid,
  pub name: String,
  pub reps: i64,
  pub sets: i64,
  pub weight_kg: f32,
  pub workouts_id: Uuid,
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct WorkoutRequest {
  pub date: DateTime<Utc>,
  pub exercises: Vec<ExerciseRequest>,
}

#[derive(Serialize)]
pub struct Workout {
  pub id: Uuid,
  pub date: DateTime<Utc>,
  pub exercises: Vec<Exercise>,
}

#[derive(FromRow)]
struct WorkoutEntry {
  pub id: Uuid,
  pub date: DateTime<Utc>,
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

  pub async fn find_all(db_pool: &SqlitePool) -> Result<Vec<Exercise>> {
    Ok(
      sqlx::query!(r#"SELECT id, name, reps, sets, weight_kg, workouts_id FROM exercises"#)
        .fetch_all(db_pool)
        .await?
        .into_iter()
        .map(|row| Exercise {
          // TODO proper Uuid support from "uuid" feature only available for postgres
          id: Uuid::from_slice(row.id.as_slice()).unwrap(),
          name: row.name,
          reps: row.reps,
          sets: row.sets,
          weight_kg: row.weight_kg,
          workouts_id: Uuid::from_slice(row.workouts_id.as_slice()).unwrap(),
        })
        .collect(),
    )
  }
}

impl WorkoutEntry {
  async fn find_all(db_pool: &SqlitePool) -> Result<Vec<WorkoutEntry>> {
    Ok(
      sqlx::query!(r#"SELECT id, date FROM workouts"#)
        .fetch_all(db_pool)
        .await?
        .into_iter()
        .map(|row| WorkoutEntry {
          id: Uuid::from_slice(row.id.as_slice()).unwrap(),
          date: DateTime::from_utc(row.date, Utc),
        })
        .collect(),
    )
  }
}

impl Workout {
  pub async fn create(workout_req: WorkoutRequest, db_pool: &SqlitePool) -> Result<Workout> {
    let mut tx = db_pool.begin().await?;
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

  pub async fn find_all(db_pool: &SqlitePool) -> Result<Vec<Workout>> {
    let exercises = Exercise::find_all(db_pool).await?;
    let mut exercises_by_workouts = HashMap::new();

    for ex in exercises {
      exercises_by_workouts
        .entry(ex.workouts_id)
        .or_insert_with(Vec::new)
        .push(ex);
    }

    Ok(
      WorkoutEntry::find_all(db_pool)
        .await?
        .into_iter()
        .map(|we| Workout {
          id: we.id,
          date: we.date,
          exercises: exercises_by_workouts.remove(&we.id).unwrap_or(Vec::new()),
        })
        .collect(),
    )
  }
}
