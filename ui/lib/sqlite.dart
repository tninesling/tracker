class Sqlite {
  static String createIngredientsTable() => """
    CREATE TABLE IF NOT EXISTS ingredients(
      id TEXT NOT NULL PRIMARY KEY,
      name TEXT NOT NULL,
      amount_grams REAL NOT NULL,
      calories REAL NOT NULL,
      carb_grams REAL NOT NULL,
      fat_grams REAL NOT NULL,
      protein_grams REAL NOT NULL,
      sugar_grams REAL NOT NULL,
      sodium_milligrams REAL NOT NULL
    );
  """;

  static String createMealsTable() => """
    CREATE TABLE IF NOT EXISTS meals(
      id TEXT NOT NULL PRIMARY KEY,
      date TEXT NOT NULL
    );
  """;

  static String createMealsIngredientsTable() => """
    CREATE TABLE IF NOT EXISTS meals_ingredients(
      meals_id TEXT NOT NULL REFERENCES meals(id) ON DELETE CASCADE,
      ingredients_id TEXT NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
      amount_grams REAL NOT NULL,
      PRIMARY KEY (meals_id, ingredients_id)
    );
  """;

  static String selectAllMealsAndIngredientAmounts() => """
    SELECT m.id, m.date, mi.ingredients_id, mi.amount_grams
    FROM meals m
    JOIN meals_ingredients mi
    ON m.id = mi.meals_id
  """;

  static String selectMealAndIngredientsForMeal() => """
    SELECT
      m.id AS meals_id,
      m.date AS date,
      i.id AS id,
      i.name AS name,
      mi.amount_grams AS amount_grams,
      i.calories / i.amount_grams * mi.amount_grams AS calories,
      i.carb_grams / i.amount_grams * mi.amount_grams AS carb_grams,
      i.fat_grams / i.amount_grams * mi.amount_grams AS fat_grams,
      i.protein_grams / i.amount_grams * mi.amount_grams AS protein_grams,
      i.sugar_grams / i.amount_grams * mi.amount_grams AS sugar_grams,
      i.sodium_milligrams / i.amount_grams * mi.amount_grams AS sodium_milligrams
    FROM meals m
    JOIN meals_ingredients mi
    ON m.id = mi.meals_id
    JOIN ingredients i
    ON mi.ingredients_id = i.id
    WHERE m.id = ?
  """;

  static String selectAllMealsAndIngredients() => """
    SELECT
      m.id AS meals_id,
      m.date AS date,
      i.id AS id,
      i.name AS name,
      mi.amount_grams AS amount_grams,
      i.calories / i.amount_grams * mi.amount_grams AS calories,
      i.carb_grams / i.amount_grams * mi.amount_grams AS carb_grams,
      i.fat_grams / i.amount_grams * mi.amount_grams AS fat_grams,
      i.protein_grams / i.amount_grams * mi.amount_grams AS protein_grams,
      i.sugar_grams / i.amount_grams * mi.amount_grams AS sugar_grams,
      i.sodium_milligrams / i.amount_grams * mi.amount_grams AS sodium_milligrams
    FROM meals m
    JOIN meals_ingredients mi
    ON m.id = mi.meals_id
    JOIN ingredients i
    ON mi.ingredients_id = i.id
  """;
}
