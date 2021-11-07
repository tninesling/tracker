pub mod db;
pub mod errors;
pub mod models;

use chrono::Timelike;

use db::Connection;
pub use errors::Error;
pub use models::{Workout, WorkoutSummary};

pub fn create_workout(conn: Connection, workout: &mut Workout) -> Result<&Workout, Error> {
    db::create_workout(conn, workout).map_err(|e| Error::DBError(e))
}

pub fn delete_workout(conn: Connection, public_id: uuid::Uuid) -> Result<(), Error> {
    db::delete_workout(conn, public_id)
        .map_err(Error::DBError)
        .and_then(|deleted| {
            if deleted {
                Ok(())
            } else {
                Err(Error::NotFound)
            }
        })
}

pub fn get_all_workouts(conn: Connection) -> Result<Vec<Workout>, Error> {
    db::get_all_workouts(conn).map_err(Error::DBError)
}

pub fn summarize_workouts(conn: Connection) -> Result<Vec<WorkoutSummary>, Error> {
    get_all_workouts(conn).map(|workouts| workouts.iter().map(summarize_workout).collect())
}

fn summarize_workout(workout: &Workout) -> WorkoutSummary {
    WorkoutSummary {
        start_date: beginning_of_day(workout.date),
        end_date: end_of_day(workout.date),
        total_weight_kg: workout
            .exercises
            .iter()
            .fold(0.0, |acc, e| acc + e.weight_kg),
    }
}

fn beginning_of_day<T: Timelike>(time_like: T) -> T {
    time_like
        .with_hour(0)
        .unwrap()
        .with_minute(0)
        .unwrap()
        .with_second(0)
        .unwrap()
        .with_nanosecond(0)
        .unwrap()
}

fn end_of_day<T: Timelike>(time_like: T) -> T {
    time_like
        .with_hour(11)
        .unwrap()
        .with_minute(59)
        .unwrap()
        .with_second(59)
        .unwrap()
        .with_nanosecond(999999999)
        .unwrap()
}
