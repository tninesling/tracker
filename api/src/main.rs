use actix_cors::Cors;
use actix_web::middleware::Logger;
use actix_web::{get, App, HttpResponse, HttpServer, Responder};
use dotenv::dotenv;
use env_logger::Env;
use sqlx::sqlite::SqlitePoolOptions;

mod summaries;
mod trends;
mod workouts;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    env_logger::Builder::from_env(Env::default().default_filter_or("info")).init();

    let db_pool = SqlitePoolOptions::new()
        .max_connections(5)
        .connect("heath.db")
        .await
        .unwrap(); // TODO error handling

    HttpServer::new(move || {
        let cors = Cors::default().allow_any_origin();

        App::new()
            .data(db_pool.clone())
            .wrap(cors)
            .wrap(Logger::default())
            .service(status)
            .configure(summaries::init)
            .configure(trends::init)
            .configure(workouts::init)
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}

#[get("/status")]
async fn status() -> impl Responder {
    HttpResponse::Ok().body("I'm alive!")
}
