pub mod db;
pub mod errors;
pub mod models;

use db::Connection;
pub use errors::Error;
pub use models::Workout;

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
