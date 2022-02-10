use crate::meals::CreateIngredientRequest;
use crate::meals::Ingredient;
use crate::meals::Meal;
use crate::storage::Database;
use crate::storage::Postgres;
use crate::ApiContext;
use dropshot::endpoint;
use dropshot::EmptyScanParams;
use dropshot::HttpError;
use dropshot::HttpResponseCreated;
use dropshot::HttpResponseOk;
use dropshot::PaginationParams;
use dropshot::Query;
use dropshot::RequestContext;
use dropshot::ResultsPage;
use dropshot::TypedBody;
use dropshot::WhichPage;
use schemars::JsonSchema;
use serde::Deserialize;
use serde::Serialize;
use std::sync::Arc;

use super::CreateMealRequest;

#[derive(Deserialize, JsonSchema, Serialize)]
pub struct OffsetPage {
    offset: i32,
}

#[endpoint {
  method = GET,
  path = "/ingredients",
}]
pub async fn get_ingredients(
    rqctx: Arc<RequestContext<ApiContext>>,
    query: Query<PaginationParams<EmptyScanParams, OffsetPage>>,
) -> Result<HttpResponseOk<ResultsPage<Ingredient>>, HttpError> {
    let ctx = rqctx.context();
    let db = Postgres::new(&ctx.db_pool);

    let pag_params = query.into_inner();
    let limit = rqctx.page_limit(&pag_params)?.get();
    let offset = match &pag_params.page {
        WhichPage::First(..) => &0,
        WhichPage::Next(OffsetPage { offset }) => offset,
    };

    let ingredients = db
        .get_ingredients(offset, &limit)
        .await
        .map_err::<HttpError, _>(|e| e.into())?;
    let next_offset = *offset + ingredients.len() as i32;
    let results_page = ResultsPage::new(ingredients, &EmptyScanParams {}, |_, _| OffsetPage {
        offset: next_offset,
    });

    results_page.map(HttpResponseOk)
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

    let ingredient = super::create_ingredient(&db, &r).await?;

    Ok(HttpResponseCreated(ingredient))
}

#[endpoint {
    method = GET,
    path = "/meals",
  }]
pub async fn get_meals(
    rqctx: Arc<RequestContext<ApiContext>>,
    query: Query<PaginationParams<EmptyScanParams, OffsetPage>>,
) -> Result<HttpResponseOk<ResultsPage<Meal>>, HttpError> {
    let ctx = rqctx.context();
    let db = Postgres::new(&ctx.db_pool);

    let pag_params = query.into_inner();
    let limit = rqctx.page_limit(&pag_params)?.get();
    let offset = match &pag_params.page {
        WhichPage::First(..) => &0,
        WhichPage::Next(OffsetPage { offset }) => offset,
    };

    let meals = db.get_meals(offset, &limit).await?;
    let next_offset = *offset + meals.len() as i32;
    let results_page = ResultsPage::new(meals, &EmptyScanParams {}, |_, _| OffsetPage {
        offset: next_offset,
    })?;

    Ok(HttpResponseOk(results_page))
}

#[endpoint {
    method = POST,
    path = "/meals",
}]
pub async fn create_meal(
    rqctx: Arc<RequestContext<ApiContext>>,
    req: TypedBody<CreateMealRequest>,
) -> Result<HttpResponseCreated<Meal>, HttpError> {
    let ctx = rqctx.context();
    let db = Postgres::new(&ctx.db_pool);
    let r = req.into_inner();

    let meal = super::create_meal(&db, r).await?;

    Ok(HttpResponseCreated(meal))
}
