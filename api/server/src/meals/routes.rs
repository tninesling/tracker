use crate::meals::CreateIngredientRequest;
use crate::meals::Ingredient;
use crate::storage::Database;
use crate::storage::Postgres;
use crate::ApiContext;
use dropshot::endpoint;
use dropshot::HttpError;
use dropshot::HttpResponseCreated;
use dropshot::HttpResponseOk;
use dropshot::RequestContext;
use dropshot::TypedBody;
use std::sync::Arc;

// TODO paginate
#[endpoint {
  method = GET,
  path = "/ingredients",
}]
pub async fn get_all_ingredients(
    rqctx: Arc<RequestContext<ApiContext>>,
) -> Result<HttpResponseOk<Vec<Ingredient>>, HttpError> {
    let ctx = rqctx.context();
    let db = Postgres::new(&ctx.db_pool);

    db.get_all_ingredients()
        .await
        .map(HttpResponseOk)
        .map_err(|e| e.into())
}

#[endpoint {
    method = POST,
    path = "/ingredients",
}]
pub async fn create_ingredient(
    rqctx: Arc<RequestContext<ApiContext>>,
    req: TypedBody<CreateIngredientRequest>,
) -> Result<HttpResponseCreated<Ingredient>, HttpError> {
    let ctx = rqctx.context();
    let db = Postgres::new(&ctx.db_pool);
    let r = req.into_inner();

    super::create_ingredient(&db, &r)
        .await
        .map(HttpResponseCreated)
        .map_err(|e| e.into())
}
