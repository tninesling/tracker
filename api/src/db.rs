use rusqlite::{params, Error};
use std::collections::HashMap;
use uuid::Uuid;

use crate::models::{Exercise, Ingredient, IngredientUnit, Meal, Workout};

pub type Pool = r2d2::Pool<r2d2_sqlite::SqliteConnectionManager>;
pub type Connection = r2d2::PooledConnection<r2d2_sqlite::SqliteConnectionManager>;

pub fn create_workout(conn: Connection, workout: &mut Workout) -> Result<&Workout, Error> {
    conn.execute(
        "INSERT INTO workouts (public_id, date) VALUES (?, ?)",
        params![workout.public_id, workout.date],
    )?;

    workout.id = conn.last_insert_rowid();

    for ex in &mut workout.exercises {
        ex.workouts_id = workout.id;
        conn.execute(
      "INSERT INTO exercises (public_id, name, reps, sets, weight_kg, workouts_id) VALUES (?, ?, ?, ?, ?, ?)",
      params![ex.public_id, ex.name, ex.reps, ex.sets, ex.weight_kg, ex.workouts_id],
    )?;
    }

    Ok(workout)
}

pub fn delete_workout(conn: Connection, public_id: Uuid) -> Result<bool, Error> {
    conn.prepare("DELETE FROM workouts WHERE public_id = ?")?
        .execute(params![public_id])
        .map(|affected_rows| affected_rows > 0)
}

pub fn get_all_workouts(conn: Connection) -> Result<Vec<Workout>, Error> {
    let exercises: Vec<Exercise> = conn
        .prepare("SELECT id, public_id, name, reps, sets, weight_kg, workouts_id FROM exercises")?
        .query_map([], |row| {
            Ok(Exercise {
                id: row.get(0)?,
                public_id: row.get(1)?,
                name: row.get(2)?,
                reps: row.get(3)?,
                sets: row.get(4)?,
                weight_kg: row.get(5)?,
                workouts_id: row.get(6)?,
            })
        })
        .and_then(Iterator::collect)?;

    let mut exercises_by_workout = HashMap::with_capacity(exercises.len());

    for exercise in exercises {
        exercises_by_workout
            .entry(exercise.workouts_id)
            .or_insert_with(Vec::new)
            .push(exercise);
    }

    conn.prepare("SELECT id, public_id, date FROM workouts")?
        .query_map([], |row| {
            let id = row.get(0)?;
            let exs = exercises_by_workout.remove(&id).unwrap_or(Vec::new());

            Ok(Workout {
                id,
                public_id: row.get(1)?,
                date: row.get(2)?,
                exercises: exs,
            })
        })
        .and_then(Iterator::collect)
}

pub fn create_ingredient(conn: Connection, ingredient: &Ingredient) -> Result<(), Error> {
    conn.execute(
        "INSERT INTO ingredients (
            public_id,
            name,
            serving_size,
            serving_unit,
            calories,
            carbohydrates_mg,
            fat_mg,
            protein_mg,
            saturated_fat_mg,
            polyunsaturated_fat_mg,
            monounsaturated_fat_mg,
            trans_fat_mg,
            fiber_mg,
            sugar_mg,
            added_sugar_mg,
            cholesterol_mg,
            sodium_mg,
            potassium_mg,
            calcium_mg,
            iron_mg
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        params![
            ingredient.public_id,
            ingredient.name,
            ingredient.serving_size,
            match ingredient.serving_unit {
                IngredientUnit::Milligrams => "mg",
                IngredientUnit::Milliliters => "ml",
            },
            ingredient.calories,
            ingredient.carbohydrates_mg,
            ingredient.fat_mg,
            ingredient.protein_mg,
            ingredient.saturated_fat_mg,
            ingredient.polyunsaturated_fat_mg,
            ingredient.monounsaturated_fat_mg,
            ingredient.trans_fat_mg,
            ingredient.fiber_mg,
            ingredient.sugar_mg,
            ingredient.added_sugar_mg,
            ingredient.cholesterol_mg,
            ingredient.sodium_mg,
            ingredient.potassium_mg,
            ingredient.calcium_mg,
            ingredient.iron_mg
        ],
    )?;

    Ok(())
}

pub fn get_all_ingredients(conn: Connection) -> Result<Vec<Ingredient>, Error> {
    conn.prepare(
        "SELECT
        id,
        public_id,
        name,
        serving_size,
        serving_unit,
        calories,
        carbohydrates_mg,
        fat_mg,
        protein_mg,
        saturated_fat_mg,
        polyunsaturated_fat_mg,
        monounsaturated_fat_mg,
        trans_fat_mg,
        fiber_mg,
        sugar_mg,
        added_sugar_mg,
        cholesterol_mg,
        sodium_mg,
        potassium_mg,
        calcium_mg,
        iron_mg
    FROM ingredients",
    )?
    .query_map([], |row| {
        Ok(Ingredient {
            id: row.get(0)?,
            public_id: row.get(1)?,
            name: row.get(2)?,
            serving_size: row.get(3)?,
            serving_unit: row.get::<_, String>(4).map(|val| {
                if val == "mg" {
                    IngredientUnit::Milligrams
                } else {
                    IngredientUnit::Milliliters
                }
            })?,
            calories: row.get(5)?,
            carbohydrates_mg: row.get(6)?,
            fat_mg: row.get(7)?,
            protein_mg: row.get(8)?,
            saturated_fat_mg: row.get(9)?,
            polyunsaturated_fat_mg: row.get(10)?,
            monounsaturated_fat_mg: row.get(11)?,
            trans_fat_mg: row.get(12)?,
            fiber_mg: row.get(13)?,
            sugar_mg: row.get(14)?,
            added_sugar_mg: row.get(15)?,
            cholesterol_mg: row.get(16)?,
            sodium_mg: row.get(17)?,
            potassium_mg: row.get(18)?,
            calcium_mg: row.get(19)?,
            iron_mg: row.get(20)?,
        })
    })
    .and_then(Iterator::collect)
}

pub fn create_meal(conn: Connection, meal: &Meal) -> Result<(), Error> {
    conn.execute(
        "INSERT INTO meals (public_id, date) VALUES (?, ?)",
        params![meal.public_id, meal.date],
    )?;

    let meal_id = conn.last_insert_rowid();

    for (ingredient_key, num_servings) in meal.ingredient_servings.iter() {
        conn.execute(
            "INSERT INTO meals_ingredients (meals_id, ingredients_id, num_servings)
            SELECT ?, id, ? FROM ingredients WHERE public_id = ?",
            params![meal_id, num_servings, ingredient_key],
        )?;
    }

    Ok(())
}

pub fn get_all_meals(conn: Connection) -> Result<Vec<Meal>, Error> {
    let mut ingredient_amounts_by_meal: HashMap<i64, HashMap<Uuid, f64>> = HashMap::new();
    let ingredient_amounts: Vec<(i64, Uuid, f64)> = conn.prepare(
        "SELECT m.meals_id, i.public_id, m.num_servings FROM meals_ingredients m JOIN ingredients i ON m.ingredients_id = i.id"
    )?.query_map([], |row| {
            let meals_id: i64 = row.get(0)?;
            let ingredients_public_id: Uuid = row.get(1)?;
            let num_servings: f64 = row.get(2)?;

            Ok((meals_id, ingredients_public_id, num_servings))
        }).and_then(Iterator::collect)?;

    for (meals_id, ingredients_public_id, num_servings) in ingredient_amounts {
        ingredient_amounts_by_meal
            .entry(meals_id)
            .or_insert_with(HashMap::new)
            .insert(ingredients_public_id, num_servings);
    }

    conn.prepare("SELECT id, public_id, date FROM meals")?
        .query_map([], |row| {
            let id = row.get(0)?;

            Ok(Meal {
                id,
                public_id: row.get(1)?,
                date: row.get(2)?,
                ingredient_servings: ingredient_amounts_by_meal
                    .remove(&id)
                    .unwrap_or(HashMap::new()),
            })
        })
        .and_then(Iterator::collect)
}
