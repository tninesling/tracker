use chrono::prelude::{DateTime, NaiveDateTime, Utc};
use rusqlite::params;
use std::collections::HashMap;
use uuid::Uuid;

use crate::models::{Exercise, Workout};

pub type Pool = r2d2::Pool<r2d2_sqlite::SqliteConnectionManager>;
pub type Connection = r2d2::PooledConnection<r2d2_sqlite::SqliteConnectionManager>;

pub fn create_workout(conn: Connection, workout: &mut Workout) -> Result<(), rusqlite::Error> {
    conn.execute(
        "INSERT INTO workouts (public_id, date) VALUES (?)",
        params![Uuid::new_v4(), workout.date],
    )?;

    workout.id = conn.last_insert_rowid();

    for ex in &mut workout.exercises {
        ex.workouts_id = workout.id;
        conn.execute(
      "INSERT INTO exercises (public_id, name, reps, sets, weight_kg, workouts_id) VALUES (?, ?, ?, ?, ?)",
      params![Uuid::new_v4(), ex.name, ex.reps, ex.sets, ex.weight_kg, ex.workouts_id],
    )?;
    }

    Ok(())
}

pub fn get_all_workouts(conn: Connection) -> Result<Vec<Workout>, rusqlite::Error> {
    let exercises: Vec<Exercise> = conn
        .prepare("SELECT id, public_id, name, reps, sets, weight_kg, workouts_id FROM exercises")?
        .query_map([], |row| {
            Ok(Exercise {
                id: row.get(0)?,
                public_id: row.get(1)?,
                name: row.get(2)?,
                reps: row.get(3)?,
                sets: row.get(4)?,
                weight_kg: row.get(5)?,
                workouts_id: row.get(6)?,
            })
        })
        .and_then(Iterator::collect)?;

    let mut exercises_by_workout = HashMap::with_capacity(exercises.len());

    for exercise in exercises {
        exercises_by_workout
            .entry(exercise.workouts_id)
            .or_insert_with(Vec::new)
            .push(exercise);
    }

    conn.prepare("SELECT id, public_id, date FROM workouts")?
        .query_map([], |row| {
            let id = row.get(0)?;
            let public_id = row.get(1)?;
            let date_ts = row.get(2)?;
            let exs = exercises_by_workout.remove(&id).unwrap_or(Vec::new());

            Ok(Workout {
                id,
                public_id,
                date: DateTime::from_utc(NaiveDateTime::from_timestamp(date_ts, 0), Utc),
                exercises: exs,
            })
        })
        .and_then(Iterator::collect)
}
