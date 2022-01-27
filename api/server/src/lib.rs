mod error;
mod meals;
mod storage;
mod trends;

use crate::error::Error;
use crate::storage::Postgres;
use crate::trends::extract_calorie_trend;
use crate::trends::get_all_ingredients;
use crate::trends::get_daily_macro_trends_since_date;
use dropshot::endpoint;
use dropshot::ApiDescription;
use dropshot::ConfigDropshot;
use dropshot::ConfigLogging;
use dropshot::ConfigLoggingLevel;
use dropshot::HttpError;
use dropshot::HttpResponseOk;
use dropshot::HttpServerStarter;
use dropshot::Query;
use dropshot::RequestContext;
use http::Response;
use http::StatusCode;
use hyper::Body;
use slog::Logger;
use sqlx::postgres::PgPool;
use sqlx::postgres::PgPoolOptions;
use std::net::Ipv4Addr;
use std::net::SocketAddr;
use std::sync::Arc;
use tokio::fs::File;
use trends::MacroTrendsQuery;
use trends::Trend;

const SPEC_FILE: &str = "spec.json";

pub async fn create_server() -> Result<HttpServerStarter<ApiContext>, String> {
    let config_dropshot: ConfigDropshot = ConfigDropshot {
        bind_address: SocketAddr::from((Ipv4Addr::new(0, 0, 0, 0), 8080)),
        request_body_max_bytes: 1024,
    };
    let api = describe_api()?;
    let spec_file = File::create(SPEC_FILE)
        .await
        .map_err(|e| format!("{}", e))?;
    let mut spec_file = spec_file.into_std().await;

    api.openapi("Heath API", env!("CARGO_PKG_VERSION"))
        .write(&mut spec_file)
        .unwrap();

    HttpServerStarter::new(
        &config_dropshot,
        api,
        create_context().await?,
        &create_logger()?,
    )
    .map_err(|error| format!("failed to create server: {}", error))
}

pub fn describe_api() -> Result<ApiDescription<ApiContext>, String> {
    let mut api = ApiDescription::new();
    api.register(live)?;
    api.register(ready)?;
    api.register(get_spec)?;
    api.register(get_calorie_trend)?;
    api.register(get_macro_trends)?;
    api.register(crate::meals::routes::create_ingredient)?;
    api.register(crate::meals::routes::get_all_ingredients)?;

    Ok(api)
}

pub async fn create_context() -> Result<ApiContext, String> {
    let db_pool = PgPoolOptions::new()
        .connect("postgres://root@cockroachdb-public:26257/heath")
        .await
        .map_err(|e| format!("{}", e))?;

    Ok(ApiContext::new(db_pool))
}

pub fn create_logger() -> Result<Logger, String> {
    let config_logging = ConfigLogging::StderrTerminal {
        level: ConfigLoggingLevel::Info,
    };
    config_logging
        .to_logger("example-basic")
        .map_err(|error| format!("failed to create logger: {}", error))
}

pub struct ApiContext {
    pub db_pool: PgPool,
}

impl ApiContext {
    pub fn new(db_pool: PgPool) -> ApiContext {
        ApiContext { db_pool }
    }
}

#[endpoint {
    method = GET,
    path = "/live"
}]
async fn live(_rqctx: Arc<RequestContext<ApiContext>>) -> Result<HttpResponseOk<()>, HttpError> {
    Ok(HttpResponseOk(()))
}

#[endpoint {
    method = GET,
    path = "/ready"
}]
async fn ready(rqctx: Arc<RequestContext<ApiContext>>) -> Result<HttpResponseOk<()>, HttpError> {
    let ctx = rqctx.context();

    let db_check = sqlx::query("SELECT 1")
        .fetch_one(&ctx.db_pool)
        .await
        .map_err(Error::DBError);

    match db_check {
        Ok(_) => Ok(HttpResponseOk(())),
        Err(_) => Err(HttpError {
            status_code: StatusCode::PRECONDITION_FAILED,
            error_code: Some("db-down".to_string()),
            internal_message: "(ノಠ益ಠ)ノ彡┻━┻ Damn database doesn't even work".to_string(),
            external_message: "Whoops!".to_string(),
        }),
    }
}

#[endpoint {
    method = GET,
    path = "/spec",
}]
async fn get_spec(_rqctx: Arc<RequestContext<ApiContext>>) -> Result<Response<Body>, HttpError> {
    let file = File::open(SPEC_FILE).await.map_err(|_| HttpError {
        status_code: StatusCode::UNPROCESSABLE_ENTITY,
        error_code: Some("no-file".to_string()),
        internal_message: "(ノಠ益ಠ)ノ彡┻━┻ Cannot open spec file".to_string(),
        external_message: "Whoops!".to_string(),
    })?;
    let file_stream = hyper_staticfile::FileBytesStream::new(file);

    Ok(Response::builder()
        .status(StatusCode::OK)
        .header(http::header::CONTENT_TYPE, "application/json".to_string())
        .body(file_stream.into_body())
        .unwrap())
}

#[endpoint {
    method = GET,
    path = "/trends/calories",
}]
async fn get_calorie_trend(
    rqctx: Arc<RequestContext<ApiContext>>,
) -> Result<HttpResponseOk<Trend>, HttpError> {
    let ctx = rqctx.context();
    let db = Postgres::new(&ctx.db_pool);

    get_all_ingredients(&db)
        .await
        .map(extract_calorie_trend)
        .map(HttpResponseOk)
        .map_err(|e| e.into())
}

#[endpoint {
    method = GET,
    path = "/trends/macros",
}]
async fn get_macro_trends(
    rqctx: Arc<RequestContext<ApiContext>>,
    query: Query<MacroTrendsQuery>,
) -> Result<HttpResponseOk<Vec<Trend>>, HttpError> {
    let ctx = rqctx.context();
    let db = Postgres::new(&ctx.db_pool);

    get_daily_macro_trends_since_date(&db, query.into_inner().date)
        .await
        .map(HttpResponseOk)
        .map_err(|e| e.into())
}
