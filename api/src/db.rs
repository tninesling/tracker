use rusqlite::{params, Error};
use std::collections::HashMap;
use uuid::Uuid;

use crate::models::{Exercise, Workout};

pub type Pool = r2d2::Pool<r2d2_sqlite::SqliteConnectionManager>;
pub type Connection = r2d2::PooledConnection<r2d2_sqlite::SqliteConnectionManager>;

pub fn create_workout(conn: Connection, workout: &mut Workout) -> Result<&Workout, Error> {
    conn.execute(
        "INSERT INTO workouts (public_id, date) VALUES (?, ?)",
        params![workout.public_id, workout.date],
    )?;

    workout.id = conn.last_insert_rowid();

    for ex in &mut workout.exercises {
        ex.workouts_id = workout.id;
        conn.execute(
      "INSERT INTO exercises (public_id, name, reps, sets, weight_kg, workouts_id) VALUES (?, ?, ?, ?, ?, ?)",
      params![ex.public_id, ex.name, ex.reps, ex.sets, ex.weight_kg, ex.workouts_id],
    )?;
    }

    Ok(workout)
}

pub fn delete_workout(conn: Connection, public_id: Uuid) -> Result<bool, Error> {
    conn.prepare("DELETE FROM workouts WHERE public_id = ?")?
        .execute(params![public_id])
        .map(|affected_rows| affected_rows > 0)
}

pub fn get_all_workouts(conn: Connection) -> Result<Vec<Workout>, Error> {
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
            let exs = exercises_by_workout.remove(&id).unwrap_or(Vec::new());

            Ok(Workout {
                id,
                public_id: row.get(1)?,
                date: row.get(2)?,
                exercises: exs,
            })
        })
        .and_then(Iterator::collect)
}
