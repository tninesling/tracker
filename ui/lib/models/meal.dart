import 'package:openapi/api.dart' as openapi;

class Meal {
  final DateTime date;
  final List<Ingredient> ingredients;

  const Meal({required this.date, required this.ingredients});
}

class Ingredient {
  final String id;
  final String name;
  final double calories;
  final double carbGrams;
  final double fatGrams;
  final double proteinGrams;

  const Ingredient(
      {required this.id,
      required this.name,
      required this.calories,
      required this.carbGrams,
      required this.fatGrams,
      required this.proteinGrams});

  factory Ingredient.fromOpenapi(openapi.Ingredient i) => Ingredient(
        id: i.id,
        name: i.name,
        calories: i.calories,
        carbGrams: i.carbGrams,
        fatGrams: i.fatGrams,
        proteinGrams: i.proteinGrams,
      );
}
