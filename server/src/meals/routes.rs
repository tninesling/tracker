use crate::ApiContext;
use chrono::DateTime;
use chrono::Utc;
use domain::meals::CreateIngredientRequest;
use domain::meals::CreateMealRequest;
use domain::meals::Ingredient;
use domain::meals::Meal;
use domain::storage::Database;
use domain::storage::Postgres;
use dropshot::endpoint;
use dropshot::EmptyScanParams;
use dropshot::HttpError;
use dropshot::HttpResponseCreated;
use dropshot::HttpResponseDeleted;
use dropshot::HttpResponseOk;
use dropshot::PaginationParams;
use dropshot::Path;
use dropshot::Query;
use dropshot::RequestContext;
use dropshot::ResultsPage;
use dropshot::TypedBody;
use dropshot::WhichPage;
use schemars::JsonSchema;
use serde::Deserialize;
use serde::Serialize;
use std::sync::Arc;

#[derive(Deserialize, JsonSchema, Serialize)]
pub struct OffsetPage {
    offset: i32,
}

#[derive(Deserialize, JsonSchema, Serialize)]
pub struct AfterDate {
    after: DateTime<Utc>,
}

#[derive(Deserialize, JsonSchema, Serialize)]
pub struct MealsIdParams {
    meals_id: uuid::Uuid,
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
    ResultsPage::new(ingredients, &EmptyScanParams {}, |_, _| OffsetPage {
        offset: next_offset,
    })
    .map(HttpResponseOk)
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

    let ingredient = domain::meals::create_ingredient(&db, &r).await?;

    Ok(HttpResponseCreated(ingredient))
}

#[endpoint {
    method = GET,
    path = "/meals",
  }]
pub async fn get_meals(
    rqctx: Arc<RequestContext<ApiContext>>,
    query: Query<PaginationParams<AfterDate, AfterDate>>,
) -> Result<HttpResponseOk<ResultsPage<Meal>>, HttpError> {
    let ctx = rqctx.context();
    let db = Postgres::new(&ctx.db_pool);

    let pag_params = query.into_inner();
    let after = match &pag_params.page {
        WhichPage::First(AfterDate { after }) => after,
        WhichPage::Next(AfterDate { after }) => after,
    };
    let limit = rqctx.page_limit(&pag_params)?.get();

    let meals = db.get_meals(after, &limit).await?;
    let last_date = meals
        .iter()
        .fold(*after, |acc, m| if m.date > acc { m.date } else { acc });
    let results_page = ResultsPage::new(meals, &EmptyScanParams {}, |_, _| AfterDate {
        after: last_date,
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

    let meal = domain::meals::create_meal(&db, r).await?;

    Ok(HttpResponseCreated(meal))
}

#[endpoint {
    method = DELETE,
    path = "/meals/{meals_id}"
}]
pub async fn delete_meal(
    rqctx: Arc<RequestContext<ApiContext>>,
    path_params: Path<MealsIdParams>,
) -> Result<HttpResponseDeleted, HttpError> {
    let ctx = rqctx.context();
    let db = Postgres::new(&ctx.db_pool);
    let params = path_params.into_inner();

    db.delete_meal(params.meals_id).await?;

    Ok(HttpResponseDeleted())
}
