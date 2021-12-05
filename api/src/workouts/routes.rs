use crate::workouts::{Workout, WorkoutRequest};
use actix_web::{post, web, HttpResponse, Responder};
use sqlx::SqlitePool;

pub fn init(cfg: &mut web::ServiceConfig) {
  cfg.service(create);
}

#[post("/workouts")]
async fn create(
  workout: web::Json<WorkoutRequest>,
  db_pool: web::Data<SqlitePool>,
) -> impl Responder {
  let result = Workout::create(workout.into_inner(), db_pool.get_ref()).await;

  match result {
    Ok(w) => HttpResponse::Ok().json(w),
    Err(_) => HttpResponse::InternalServerError().body("Whoops!"), // TODO use error
  }
}
