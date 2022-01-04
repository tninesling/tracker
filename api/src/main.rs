// use actix_cors::Cors;
use actix_web::middleware::Logger;
use actix_web::{get, web, App, HttpResponse, HttpServer, Responder};
use deadpool_postgres::{Config, ManagerConfig, Pool, RecyclingMethod, Runtime};
use dotenv::dotenv;
use env_logger::Env;
use tokio_postgres::NoTls;

mod trends;

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    dotenv().ok();
    env_logger::Builder::from_env(Env::default().default_filter_or("info")).init();

    println!("Setting up DB config");

    let mut cfg = Config::new();
    cfg.host = Some("cockroachdb-public".to_string());
    cfg.dbname = Some("heath".to_string());
    cfg.manager = Some(ManagerConfig { recycling_method: RecyclingMethod::Fast });

    println!("Creating pool");

    let pool = cfg.create_pool(Some(Runtime::Tokio1), NoTls).unwrap();

    println!("Starting server");

    HttpServer::new(move || {
        //let cors = Cors::default().allow_any_origin();

        App::new()
            .app_data(web::Data::new(pool.clone()))
            //.wrap(cors)
            .wrap(Logger::default())
            .service(status)
            .configure(trends::init)
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}

#[get("/status")]
async fn status(db_pool: web::Data<Pool>) -> impl Responder {
    println!("Ok, let's see that status");

    if let Ok(client) = db_pool.get().await {
        println!("Got a client");
        if let Ok(_) = client.query("SELECT 1", &[]).await {
            return HttpResponse::Ok().body("I'm alive!");
        }
    }

    HttpResponse::PreconditionFailed().body("I'm dead!")
}
