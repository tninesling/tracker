ALTER TABLE ingredients ADD COLUMN IF NOT EXISTS amount_grams REAL NOT NULL;

CREATE TABLE IF NOT EXISTS recipes(
  id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS recipes_ingredients(
  recipes_id UUID REFERENCES recipes(id) ON DELETE CASCADE,
  ingredients_id UUID REFERENCES ingredients(id),
  amount_grams REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS meals(
  id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  date TIMESTAMPTZ NOT NULL
);

CREATE TABLE IF NOT EXISTS meals_ingredients(
  meals_id UUID REFERENCES meals(id) ON DELETE CASCADE,
  ingredients_id UUID REFERENCES ingredients(id),
  amount_grams REAL NOT NULL
);