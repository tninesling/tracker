CREATE TABLE IF NOT EXISTS workouts(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  public_id BLOB,
  date INTEGER
);

CREATE TABLE IF NOT EXISTS exercises(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  public_id BLOB,
  name TEXT,
  reps INTEGER,
  sets INTEGER,
  weight_kg REAL,
  workouts_id REFERENCES workouts(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS meals(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  public_id BLOB,
  date INTEGER
);

CREATE TABLE IF NOT EXISTS ingredients(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  public_id BLOB,
  name TEXT,
  serving_size REAL,
  serving_unit TEXT,
  calories REAL,
  carbohydrates_g REAL,
  fat_g REAL,
  protein_g REAL,
  saturated_fat_g REAL,
  polyunsaturated_fat_g REAL,
  monounsaturated_fat_g REAL,
  trans_fat_g REAL,
  fiber_mg REAL,
  sugar_mg REAL,
  added_sugar_mg REAL,
  cholesterol_mg REAL,
  sodium_mg REAL,
  potassium_mg REAL,
  calcium_mg REAL,
  iron_mg REAL
);

CREATE TABLE IF NOT EXISTS meals_ingredients(
  meals_id REFERENCES meals(id) ON DELETE CASCADE,
  ingredients_id REFERENCES ingredients(id) ON DELETE CASCADE,
  num_servings REAL,
  PRIMARY KEY (meals_id, ingredients_id)
);

CREATE TABLE IF NOT EXISTS weigh_ins(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  date INTEGER,
  weight_lbs REAL
);