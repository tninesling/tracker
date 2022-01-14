INSERT INTO ingredients
  (id, name, calories, carb_grams, fat_grams, protein_grams, amount_grams)
VALUES
  ('00193af6-1a16-4bb6-bee0-6c7d282b4ddc', 'Ingredient1', 650, 17, 25, 10, 25.3),
  ('3c9d743c-946a-4e1d-b50a-b236dfa4feea', 'Ingredient2', 300, 28, 0, 3, 38),
  ('c4adb381-73ea-489b-91a9-4d023f541d0a', 'Ingredient3', 420, 20, 20, 20, 15.3)
ON CONFLICT DO NOTHING;