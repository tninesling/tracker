use dropshot::endpoint;
use dropshot::ApiDescription;
use dropshot::ConfigDropshot;
use dropshot::ConfigLogging;
use dropshot::ConfigLoggingLevel;
use dropshot::HttpError;
use dropshot::HttpResponseOk;
use dropshot::HttpResponseUpdatedNoContent;
use dropshot::HttpServerStarter;
use dropshot::RequestContext;
use dropshot::TypedBody;
use http::StatusCode;
use schemars::JsonSchema;
use serde::Deserialize;
use serde::Serialize;
use sqlx::postgres::PgPool;
use sqlx::postgres::PgPoolOptions;
use std::net::Ipv4Addr;
use std::net::SocketAddr;
use std::sync::Arc;

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
    api.register(example_api_put_counter).unwrap();

    /*
     * The functions that implement our API endpoints will share this context.
     */
    let db_pool = PgPoolOptions::new().connect("postgres://root@cockroachdb-public:26257/heath").await.unwrap();
    let api_context = ExampleContext::new(db_pool);

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
struct ExampleContext {
    pub db_pool: PgPool,
}

impl ExampleContext {
    pub fn new(db_pool: PgPool) -> ExampleContext {
        ExampleContext {
            db_pool,
        }
    }
}

/*
 * HTTP API interface
 */

/**
 * `CounterValue` represents the value of the API's counter, either as the
 * response to a GET request to fetch the counter or as the body of a PUT
 * request to update the counter.
 */
#[derive(Deserialize, Serialize, JsonSchema)]
struct CounterValue {
    counter: u64,
}

#[endpoint {
    method = GET,
    path = "/live"
}]
async fn live(
    _rqctx: Arc<RequestContext<ExampleContext>>,
) -> Result<HttpResponseOk<()>, HttpError> {
    Ok(HttpResponseOk(()))
}

#[endpoint {
    method = GET,
    path = "/ready"
}]
async fn ready(
    rqctx: Arc<RequestContext<ExampleContext>>,
) -> Result<HttpResponseOk<()>, HttpError> {
    let ctx = rqctx.context();

    let db_check = sqlx::query("SELECT 1").fetch_one(&ctx.db_pool).await;

    match db_check {
        Ok(_) => Ok(HttpResponseOk(())),
        Err(e) => Err(HttpError {
            status_code: StatusCode::PRECONDITION_FAILED,
            error_code: Some("db-down".to_string()),
            internal_message: "(ノಠ益ಠ)ノ彡┻━┻ Damn database doesn't even work".to_string(),
            external_message: "Whoops!".to_string(),
        })
    }
}

/**
 * Update the current value of the counter.  Note that the special value of 10
 * is not allowed (just to demonstrate how to generate an error).
 */
#[endpoint {
    method = PUT,
    path = "/counter",
}]
async fn example_api_put_counter(
    rqctx: Arc<RequestContext<ExampleContext>>,
    update: TypedBody<CounterValue>,
) -> Result<HttpResponseUpdatedNoContent, HttpError> {
    let api_context = rqctx.context();
    let updated_value = update.into_inner();

    if updated_value.counter == 10 {
        Err(HttpError::for_bad_request(
            Some(String::from("BadInput")),
            format!("do not like the number {}", updated_value.counter),
        ))
    } else {
        Ok(HttpResponseUpdatedNoContent())
    }
}