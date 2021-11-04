pub mod db;
pub mod models;
use db::Connection;
pub use models::Workout;

pub enum Error {
    DBError,
}

pub fn create_workout(conn: Connection, workout: &mut Workout) -> Result<&Workout, Error> {
    match db::create_workout(conn, workout) {
        Ok(_) => Ok(workout),
        Err(_) => Err(Error::DBError),
    }
}

pub fn get_all_workouts(conn: Connection) -> Result<Vec<Workout>, Error> {
    db::get_all_workouts(conn).map_err(|_| Error::DBError)
}
