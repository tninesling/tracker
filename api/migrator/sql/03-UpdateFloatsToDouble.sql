ALTER TABLE ingredients
  ALTER amount_grams TYPE DOUBLE PRECISION,
  ALTER calories TYPE DOUBLE PRECISION,
  ALTER carb_grams TYPE DOUBLE PRECISION,
  ALTER fat_grams TYPE DOUBLE PRECISION,
  ALTER protein_grams TYPE DOUBLE PRECISION;

ALTER TABLE meals_ingredients
  ALTER amount_grams TYPE DOUBLE PRECISION;