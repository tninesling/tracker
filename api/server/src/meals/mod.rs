mod models;
pub(crate) mod routes;

pub use models::*;

use crate::error::Result;
use crate::storage::Database;

async fn create_ingredient<DB>(db: &DB, req: &CreateIngredientRequest) -> Result<Ingredient> where DB: Database {
    db.create_ingredient(req)
        .await
        .map(|id| Ingredient::builder()
            .id(id)
            .name(req.name.to_string())
            .amount_grams(req.amount_grams)
            .calories(req.calories)
            .carb_grams(req.carb_grams)
            .fat_grams(req.fat_grams)
            .protein_grams(req.protein_grams)
            .build()
        )
        .map_err(|e| e.into())
}