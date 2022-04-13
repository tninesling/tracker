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
}
