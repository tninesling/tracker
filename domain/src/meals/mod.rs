mod models;

pub use models::*;

use crate::error::Result;
use crate::storage::Database;

pub async fn create_ingredient<DB>(db: &DB, req: &CreateIngredientRequest) -> Result<Ingredient>
where
    DB: Database,
{
    db.create_ingredient(req.validate()?).await.map(|id| {
        Ingredient::builder()
            .id(id)
            .name(req.name.to_string())
            .amount_grams(req.amount_grams)
            .calories(req.calories)
            .carb_grams(req.carb_grams)
            .fat_grams(req.fat_grams)
            .protein_grams(req.protein_grams)
            .sugar_grams(req.sugar_grams)
            .sodium_milligrams(req.sodium_milligrams)
            .build()
    })
}

pub async fn create_meal<DB>(db: &DB, req: CreateMealRequest) -> Result<Meal>
where
    DB: Database,
{
    let meals_id = db.create_meal(&req).await?;

    Ok(Meal::builder()
        .id(meals_id)
        .date(req.date)
        .ingredients(db.get_meal_ingredients(meals_id).await?)
        .build())
}
