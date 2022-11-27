INSERT INTO meals
  (id, date)
VALUES
  ('751c6ae5-0bc2-4bec-b5cc-36d1b9a939d5', NOW() - INTERVAL '3 days'),
  ('b56433ec-275f-468b-9c0c-8b15ed8a962f', NOW() - INTERVAL '2 days'),
  ('c5c9ee19-1775-418b-92e0-bd676b0544b8', NOW() - INTERVAL '1 day'),
  ('8e2946ef-0527-4efb-a1a3-94a2cb485440', NOW())
ON CONFLICT DO NOTHING;

INSERT INTO meals_ingredients
 (meals_id, ingredients_id, amount_grams)
VALUES
  ('751c6ae5-0bc2-4bec-b5cc-36d1b9a939d5', '00193af6-1a16-4bb6-bee0-6c7d282b4ddc', 23),
  ('b56433ec-275f-468b-9c0c-8b15ed8a962f', '00193af6-1a16-4bb6-bee0-6c7d282b4ddc', 13),
  ('b56433ec-275f-468b-9c0c-8b15ed8a962f', '3c9d743c-946a-4e1d-b50a-b236dfa4feea', 12.5),
  ('c5c9ee19-1775-418b-92e0-bd676b0544b8', '00193af6-1a16-4bb6-bee0-6c7d282b4ddc', 10),
  ('8e2946ef-0527-4efb-a1a3-94a2cb485440', '3c9d743c-946a-4e1d-b50a-b236dfa4feea', 14.6),
  ('8e2946ef-0527-4efb-a1a3-94a2cb485440', 'c4adb381-73ea-489b-91a9-4d023f541d0a', 13.8)
ON CONFLICT DO NOTHING;