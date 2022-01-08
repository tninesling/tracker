CREATE TABLE IF NOT EXISTS ingredients(
  id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
  calories REAL NOT NULL,
  carb_grams REAL NOT NULL,
  fat_grams REAL NOT NULL,
  protein_grams REAL NOT NULL
);