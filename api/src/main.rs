use actix_cors::Cors;
use actix_web::middleware::Logger;
use actix_web::{delete, get, post, web, App, HttpResponse, HttpServer, Responder};
use env_logger::Env;
use r2d2_sqlite::{self, SqliteConnectionManager};
use uuid::Uuid;

use api::db::Pool;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env_logger::Builder::from_env(Env::default().default_filter_or("info")).init();

    let manager = SqliteConnectionManager::file("life_manager.db");
    let pool = Pool::new(manager).unwrap();
    HttpServer::new(move || {
        let cors = Cors::default().allow_any_origin();

        App::new()
            .data(pool.clone())
            .wrap(cors)
            .wrap(Logger::default())
            .service(status)
            .service(create_workout)
            .service(get_all_workouts)
            .service(get_workout_summaries)
            .service(delete_workout)
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}

#[get("/status")]
async fn status() -> impl Responder {
    HttpResponse::Ok().body("I'm alive!")
}

#[post("/workouts")]
async fn create_workout(
    db_pool: web::Data<Pool>,
    workout: web::Json<api::Workout>,
) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::create_workout(conn, &mut workout.into_inner()) {
        Ok(workout) => HttpResponse::Created().json(workout),
        Err(e) => e.into(),
    }
}

#[get("/workouts")]
async fn get_all_workouts(db_pool: web::Data<Pool>) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::get_all_workouts(conn) {
        Ok(workouts) => HttpResponse::Ok().json(workouts),
        Err(e) => e.into(),
    }
}

#[get("/workouts/summaries")]
async fn get_workout_summaries(db_pool: web::Data<Pool>) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::summarize_workouts(conn) {
        Ok(summaries) => HttpResponse::Ok().json(summaries),
        Err(e) => e.into(),
    }
}

#[delete("/workouts/{public_id}")]
async fn delete_workout(db_pool: web::Data<Pool>, path: web::Path<String>) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match Uuid::parse_str(&path.0)
        .map_err(api::Error::UuidParseError)
        .and_then(|uuid| api::delete_workout(conn, uuid))
    {
        Ok(_) => HttpResponse::Ok().body(""),
        Err(e) => e.into(),
    }
}
