use dropshot::endpoint;
use dropshot::ApiDescription;
use dropshot::ConfigDropshot;
use dropshot::ConfigLogging;
use dropshot::ConfigLoggingLevel;
use dropshot::HttpError;
use dropshot::HttpResponseOk;
use dropshot::HttpServerStarter;
use dropshot::RequestContext;
use http::StatusCode;
use sqlx::postgres::PgPool;
use sqlx::postgres::PgPoolOptions;
use trends::Point;
use trends::Trend;
use trends::linear_regression;
use std::net::Ipv4Addr;
use std::net::SocketAddr;
use std::sync::Arc;

use crate::trends::get_all_ingredients;

mod trends;

#[tokio::main]
async fn main() -> Result<(), String> {
    /*
     * We must specify a configuration with a bind address.  We'll use 127.0.0.1
     * since it's available and won't expose this server outside the host.  We
     * request port 0, which allows the operating system to pick any available
     * port.
     */
    let config_dropshot: ConfigDropshot = ConfigDropshot {
        bind_address: SocketAddr::from((Ipv4Addr::new(0, 0, 0, 0), 8080)),
        request_body_max_bytes: 1024,
    };

    /*
     * For simplicity, we'll configure an "info"-level logger that writes to
     * stderr assuming that it's a terminal.
     */
    let config_logging = ConfigLogging::StderrTerminal {
        level: ConfigLoggingLevel::Info,
    };
    let log = config_logging
        .to_logger("example-basic")
        .map_err(|error| format!("failed to create logger: {}", error))?;

    /*
     * Build a description of the API.
     */
    let mut api = ApiDescription::new();
    api.register(live).unwrap();
    api.register(ready).unwrap();
    api.register(get_calorie_trend).unwrap();
    api.register(get_carb_trend).unwrap();
    api.register(get_fat_trend).unwrap();
    api.register(get_protein_trend).unwrap();

    /*
     * The functions that implement our API endpoints will share this context.
     */
    let db_pool = PgPoolOptions::new().connect("postgres://root@cockroachdb-public:26257/heath").await.unwrap();
    let api_context = ApiContext::new(db_pool);

    /*
     * Set up the server.
     */
    let server =
        HttpServerStarter::new(&config_dropshot, api, api_context, &log)
            .map_err(|error| format!("failed to create server: {}", error))?
            .start();

    /*
     * Wait for the server to stop.  Note that there's not any code to shut down
     * this server, so we should never get past this point.
     */
    server.await
}

/**
 * Application-specific example context (state shared by handler functions)
 */
struct ApiContext {
    pub db_pool: PgPool,
}

impl ApiContext {
    pub fn new(db_pool: PgPool) -> ApiContext {
        ApiContext {
            db_pool,
        }
    }
}

/*
 * HTTP API interface
 */

#[endpoint {
    method = GET,
    path = "/live"
}]
async fn live(
    _rqctx: Arc<RequestContext<ApiContext>>,
) -> Result<HttpResponseOk<()>, HttpError> {
    Ok(HttpResponseOk(()))
}

#[endpoint {
    method = GET,
    path = "/ready"
}]
async fn ready(
    rqctx: Arc<RequestContext<ApiContext>>,
) -> Result<HttpResponseOk<()>, HttpError> {
    let ctx = rqctx.context();

    let db_check = sqlx::query("SELECT 1").fetch_one(&ctx.db_pool).await;

    match db_check {
        Ok(_) => Ok(HttpResponseOk(())),
        Err(_) => Err(HttpError { // TODO log error
            status_code: StatusCode::PRECONDITION_FAILED,
            error_code: Some("db-down".to_string()),
            internal_message: "(ノಠ益ಠ)ノ彡┻━┻ Damn database doesn't even work".to_string(),
            external_message: "Whoops!".to_string(),
        })
    }
}

#[endpoint {
    method = GET,
    path = "/trends/calories",
}]
async fn get_calorie_trend(
    rqctx: Arc<RequestContext<ApiContext>>
) -> Result<HttpResponseOk<Trend>, HttpError> {
    let ctx = rqctx.context();
    let ingredients = get_all_ingredients(&ctx.db_pool).await.unwrap(); // TODO handle error response

    let mut points = Vec::with_capacity(ingredients.len());
    let mut index = 0.0;
    for ingredient in ingredients {
        points.push(Point {
            x: index,
            y: ingredient.calories,
            label: ingredient.name,
        });
        index += 1.0;
    }

    let trend_line = linear_regression(&points);

    Ok(HttpResponseOk(Trend {
        points,
        line: trend_line,
    }))
}

#[endpoint {
    method = GET,
    path = "/trends/carbs",
}]
async fn get_carb_trend(
    rqctx: Arc<RequestContext<ApiContext>>
) -> Result<HttpResponseOk<Trend>, HttpError> {
    let ctx = rqctx.context();
    let ingredients = get_all_ingredients(&ctx.db_pool).await.unwrap(); // TODO handle error response

    let mut points = Vec::with_capacity(ingredients.len());
    let mut index = 0.0;
    for ingredient in ingredients {
        points.push(Point {
            x: index,
            y: ingredient.carb_grams,
            label: ingredient.name,
        });
        index += 1.0;
    }

    let trend_line = linear_regression(&points);

    Ok(HttpResponseOk(Trend {
        points,
        line: trend_line,
    }))
}

#[endpoint {
    method = GET,
    path = "/trends/fat",
}]
async fn get_fat_trend(
    rqctx: Arc<RequestContext<ApiContext>>
) -> Result<HttpResponseOk<Trend>, HttpError> {
    let ctx = rqctx.context();
    let ingredients = get_all_ingredients(&ctx.db_pool).await.unwrap(); // TODO handle error response

    let mut points = Vec::with_capacity(ingredients.len());
    let mut index = 0.0;
    for ingredient in ingredients {
        points.push(Point {
            x: index,
            y: ingredient.fat_grams,
            label: ingredient.name,
        });
        index += 1.0;
    }

    let trend_line = linear_regression(&points);

    Ok(HttpResponseOk(Trend {
        points,
        line: trend_line,
    }))
}

#[endpoint {
    method = GET,
    path = "/trends/protein",
}]
async fn get_protein_trend(
    rqctx: Arc<RequestContext<ApiContext>>
) -> Result<HttpResponseOk<Trend>, HttpError> {
    let ctx = rqctx.context();
    let ingredients = get_all_ingredients(&ctx.db_pool).await.unwrap(); // TODO handle error response

    let mut points = Vec::with_capacity(ingredients.len());
    let mut index = 0.0;
    for ingredient in ingredients {
        points.push(Point {
            x: index,
            y: ingredient.protein_grams,
            label: ingredient.name,
        });
        index += 1.0;
    }

    let trend_line = linear_regression(&points);

    Ok(HttpResponseOk(Trend {
        points,
        line: trend_line,
    }))
}