pub mod db;
pub mod errors;
pub mod models;

use db::Connection;
use errors::Error;
pub use models::Workout;

pub fn create_workout(conn: Connection, workout: &mut Workout) -> Result<&Workout, Error> {
    db::create_workout(conn, workout).map_err(|e| Error::DBError(e))
}

pub fn get_all_workouts(conn: Connection) -> Result<Vec<Workout>, Error> {
    db::get_all_workouts(conn).map_err(|e| Error::DBError(e))
}
