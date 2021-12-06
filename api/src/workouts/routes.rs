use crate::workouts::{Workout, WorkoutRequest};
use actix_web::{delete, get, post, web, HttpResponse, Responder};
use sqlx::SqlitePool;
use uuid::Uuid;

pub fn init(cfg: &mut web::ServiceConfig) {
  cfg.service(create).service(get_all).service(delete);
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

#[delete("/workouts/{id}")]
async fn delete(path: web::Path<String>, db_pool: web::Data<SqlitePool>) -> impl Responder {
  let id = Uuid::parse_str(&path.0).unwrap(); // TODO handle this

  match Workout::delete(id, db_pool.get_ref()).await {
    Ok(_) => HttpResponse::Ok().body(""),
    Err(_) => HttpResponse::InternalServerError().body("Whoops!"),
  }
}
