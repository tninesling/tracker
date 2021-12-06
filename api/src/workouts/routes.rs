use crate::workouts::{Workout, WorkoutRequest};
use actix_web::{get, post, web, HttpResponse, Responder};
use sqlx::SqlitePool;

pub fn init(cfg: &mut web::ServiceConfig) {
  cfg.service(create).service(get_all);
}

// TODO construct error messages from errors

#[get("/workouts")]
async fn get_all(db_pool: web::Data<SqlitePool>) -> impl Responder {
  let result = Workout::find_all(db_pool.get_ref()).await;

  match result {
    Ok(ws) => HttpResponse::Ok().json(ws),
    Err(_) => HttpResponse::InternalServerError().body("Whoops!"),
  }
}

#[post("/workouts")]
async fn create(
  workout: web::Json<WorkoutRequest>,
  db_pool: web::Data<SqlitePool>,
) -> impl Responder {
  let result = Workout::create(workout.into_inner(), db_pool.get_ref()).await;

  match result {
    Ok(w) => HttpResponse::Ok().json(w),
    Err(_) => HttpResponse::InternalServerError().body("Whoops!"),
  }
}
