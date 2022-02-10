use crate::storage::Postgres;
use crate::trends::get_daily_macro_trends_since_date;
use crate::trends::MacroTrendsQuery;
use crate::trends::Trend;
use crate::ApiContext;
use dropshot::endpoint;
use dropshot::HttpError;
use dropshot::HttpResponseOk;
use dropshot::Query;
use dropshot::RequestContext;
use std::sync::Arc;

#[endpoint {
  method = GET,
  path = "/trends/macros",
}]
pub async fn get_macro_trends(
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
