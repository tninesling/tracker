pub mod db;
pub mod errors;
pub mod models;

use chrono::{Timelike, Utc};

use db::Connection;
pub use errors::Error;
pub use models::*;

pub fn create_workout<'a, 'b>(
    conn: &'a Connection,
    workout: &'b mut Workout,
) -> Result<&'b Workout, Error> {
    db::create_workout(conn, workout).map_err(|e| Error::DBError(e))
}

pub fn delete_workout(conn: &Connection, public_id: uuid::Uuid) -> Result<(), Error> {
    db::delete_workout(conn, public_id)
        .map_err(Error::DBError)
        .and_then(|deleted| {
            if deleted {
                Ok(())
            } else {
                Err(Error::NotFound)
            }
        })
}

pub fn get_all_workouts(conn: &Connection) -> Result<Vec<Workout>, Error> {
    db::get_all_workouts(conn).map_err(Error::DBError)
}

pub fn summarize_workouts(conn: &Connection) -> Result<Vec<WorkoutSummary>, Error> {
    get_all_workouts(conn).map(|workouts| {
        workouts
            .iter()
            .map(|workout| WorkoutSummary {
                start_date: beginning_of_day(workout.date),
                end_date: end_of_day(workout.date),
                total_weight_kg: workout
                    .exercises
                    .iter()
                    .fold(0.0, |acc, e| acc + e.weight_kg),
            })
            .collect()
    })
}

fn beginning_of_day<T: Timelike>(time_like: T) -> T {
    time_like
        .with_hour(0)
        .unwrap()
        .with_minute(0)
        .unwrap()
        .with_second(0)
        .unwrap()
        .with_nanosecond(0)
        .unwrap()
}

fn end_of_day<T: Timelike>(time_like: T) -> T {
    time_like
        .with_hour(11)
        .unwrap()
        .with_minute(59)
        .unwrap()
        .with_second(59)
        .unwrap()
        .with_nanosecond(999999999)
        .unwrap()
}

pub fn create_ingredient(conn: &Connection, ingredient: &Ingredient) -> Result<(), Error> {
    db::create_ingredient(conn, ingredient).map_err(Error::DBError)
}

pub fn get_all_ingredients(conn: &Connection) -> Result<Vec<Ingredient>, Error> {
    db::get_all_ingredients(conn).map_err(Error::DBError)
}

pub fn create_meal(conn: &mut Connection, meal: &Meal) -> Result<(), Error> {
    db::create_meal(conn, meal).map_err(Error::DBError)
}

pub fn get_all_meals(conn: &Connection) -> Result<Vec<Meal>, Error> {
    db::get_all_meals(conn).map_err(Error::DBError)
}

pub fn summarize_meals(conn: &Connection) -> Result<Vec<MealSummary>, Error> {
    let mut meal_summaries = Vec::new();
    let meals = get_all_meals(conn)?;

    for meal in meals {
        let ingredients = db::get_ingredients_for_meal(conn, &meal).map_err(Error::DBError)?;

        meal_summaries.push(summarize_meal_ingredients(&meal, ingredients))
    }

    Ok(meal_summaries)
}

pub fn summarize_todays_meals(conn: &Connection) -> Result<MealSummary, Error> {
    let meal_summaries = summarize_meals(conn)?;
    let this_morning = beginning_of_day(Utc::now());

    Ok(meal_summaries
        .iter()
        .filter(|ms| ms.start_date > this_morning)
        .fold(MealSummary::new(), |acc, x| acc + x))
}

fn summarize_meal_ingredients(meal: &Meal, ingredients: Vec<Ingredient>) -> MealSummary {
    let mut summary = MealSummary {
        start_date: meal.date,
        end_date: meal.date,
        calories: 0.0,
        carbohydrates_mg: 0.0,
        fat_mg: 0.0,
        protein_mg: 0.0,
    };

    for ingredient in ingredients {
        let num_servings = meal
            .ingredient_servings
            .get(&ingredient.public_id)
            .unwrap_or(&0.0);

        summary.calories += num_servings * ingredient.calories;
        summary.carbohydrates_mg += num_servings * ingredient.carbohydrates_mg;
        summary.fat_mg += num_servings * ingredient.fat_mg;
        summary.protein_mg += num_servings * ingredient.protein_mg;
    }

    summary
}
