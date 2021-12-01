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
            .service(create_ingredient)
            .service(get_all_ingredients)
            .service(create_meal)
            .service(get_all_meals)
            .service(get_meal_summaries)
            .service(get_todays_meal_summary)
            .service(create_weigh_in)
            .service(get_all_weigh_ins)
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

    match api::create_workout(&conn, &mut workout.into_inner()) {
        Ok(workout) => HttpResponse::Created().json(workout),
        Err(e) => e.into(),
    }
}

#[get("/workouts")]
async fn get_all_workouts(db_pool: web::Data<Pool>) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::get_all_workouts(&conn) {
        Ok(workouts) => HttpResponse::Ok().json(workouts),
        Err(e) => e.into(),
    }
}

#[get("/workouts/summaries")]
async fn get_workout_summaries(db_pool: web::Data<Pool>) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::summarize_workouts(&conn) {
        Ok(summaries) => HttpResponse::Ok().json(summaries),
        Err(e) => e.into(),
    }
}

#[delete("/workouts/{public_id}")]
async fn delete_workout(db_pool: web::Data<Pool>, path: web::Path<String>) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match Uuid::parse_str(&path.0)
        .map_err(api::Error::UuidParseError)
        .and_then(|uuid| api::delete_workout(&conn, uuid))
    {
        Ok(_) => HttpResponse::Ok().body(""),
        Err(e) => e.into(),
    }
}

#[get("/ingredients")]
async fn get_all_ingredients(db_pool: web::Data<Pool>) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::get_all_ingredients(&conn) {
        Ok(ingredients) => HttpResponse::Ok().json(ingredients),
        Err(e) => e.into(),
    }
}

#[post("/ingredients")]
async fn create_ingredient(
    db_pool: web::Data<Pool>,
    ingredient: web::Json<api::Ingredient>,
) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::create_ingredient(&conn, &ingredient.into_inner()) {
        Ok(_) => HttpResponse::Ok().body(""),
        Err(e) => e.into(),
    }
}

#[get("/meals")]
async fn get_all_meals(db_pool: web::Data<Pool>) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::get_all_meals(&conn) {
        Ok(meals) => HttpResponse::Ok().json(meals),
        Err(e) => e.into(),
    }
}

#[post("/meals")]
async fn create_meal(db_pool: web::Data<Pool>, meal: web::Json<api::Meal>) -> impl Responder {
    let mut conn = db_pool.get().unwrap();

    match api::create_meal(&mut conn, &meal) {
        Ok(_) => HttpResponse::Ok().body(""),
        Err(e) => e.into(),
    }
}

#[get("/meals/summaries")]
async fn get_meal_summaries(db_pool: web::Data<Pool>) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::summarize_meals(&conn) {
        Ok(summaries) => HttpResponse::Ok().json(summaries),
        Err(e) => e.into(),
    }
}

#[get("/meals/summaries/today")]
async fn get_todays_meal_summary(db_pool: web::Data<Pool>) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::summarize_todays_meals(&conn) {
        Ok(summary) => HttpResponse::Ok().json(summary),
        Err(e) => e.into(),
    }
}

#[post("/weighins")]
async fn create_weigh_in(
    db_pool: web::Data<Pool>,
    weigh_in: web::Json<api::WeighIn>,
) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::create_weigh_in(&conn, &weigh_in) {
        Ok(_) => HttpResponse::Created().body(""),
        Err(e) => e.into(),
    }
}

#[get("/weighins")]
async fn get_all_weigh_ins(db_pool: web::Data<Pool>) -> impl Responder {
    let conn = db_pool.get().unwrap();

    match api::get_all_weigh_ins(&conn) {
        Ok(weigh_ins) => HttpResponse::Ok().json(weigh_ins),
        Err(e) => e.into(),
    }
}
