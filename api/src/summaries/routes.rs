use crate::summaries::{condense_summaries_by_day, summarize_workout, WorkoutSummary};
use crate::workouts::Workout;
use actix_web::{get, web, HttpResponse, Responder};
use anyhow::Result;
use sqlx::SqlitePool;

pub fn init(cfg: &mut web::ServiceConfig) {
    cfg.service(get_workout_summaries);
}

#[get("/summaries/workouts")]
async fn get_workout_summaries(db_pool: web::Data<SqlitePool>) -> impl Responder {
    let result: Result<Vec<WorkoutSummary>> =
        Workout::find_all(db_pool.get_ref()).await.map(|workouts| {
            condense_summaries_by_day(workouts.iter().map(summarize_workout).collect())
        });

    match result {
        Ok(summaries) => HttpResponse::Ok().json(summaries),
        Err(_) => HttpResponse::InternalServerError().body("Whoops!"),
    }
}
