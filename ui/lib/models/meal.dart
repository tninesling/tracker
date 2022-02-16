import 'package:openapi/api.dart' as openapi;

class Meal {
  final DateTime date;
  final List<Ingredient> ingredients;
  late final double calories;
  late final double carbGrams;
  late final double fatGrams;
  late final double proteinGrams;

  Meal({required this.date, required this.ingredients}) {
    calories = ingredients.fold(0.0, (acc, i) {
      return acc + i.calories;
    });
    carbGrams = ingredients.fold(0.0, (acc, i) {
      return acc + i.carbGrams;
    });
    fatGrams = ingredients.fold(0.0, (acc, i) {
      return acc + i.fatGrams;
    });
    proteinGrams = ingredients.fold(0.0, (acc, i) {
      return acc + i.proteinGrams;
    });
  }

  factory Meal.empty() => Meal(date: DateTime.now(), ingredients: []);

  factory Meal.fromOpenapi(openapi.Meal m) => Meal(
        date: m.date,
        ingredients: m.ingredients.map(Ingredient.fromOpenapi).toList(),
      );

  Meal add(Meal other) => Meal(
        date: date,
        ingredients: [...ingredients, ...other.ingredients],
      );
}

class CreateMealRequest {
  final DateTime date;
  final Map<String, double> ingredientAmounts;

  const CreateMealRequest({
    required this.date,
    required this.ingredientAmounts,
  });

  openapi.CreateMealRequest toOpenapi() {
    return openapi.CreateMealRequest(
      date: date,
      ingredientAmounts: ingredientAmounts,
    );
  }
}

class Ingredient {
  final String id;
  final String name;
  final double amountGrams;
  final double calories;
  final double carbGrams;
  final double fatGrams;
  final double proteinGrams;

  const Ingredient(
      {required this.id,
      required this.name,
      required this.amountGrams,
      required this.calories,
      required this.carbGrams,
      required this.fatGrams,
      required this.proteinGrams});

  factory Ingredient.fromOpenapi(openapi.Ingredient i) => Ingredient(
        id: i.id,
        name: i.name,
        amountGrams: i.amountGrams,
        calories: i.calories,
        carbGrams: i.carbGrams,
        fatGrams: i.fatGrams,
        proteinGrams: i.proteinGrams,
      );
}

class CreateIngredientRequest {
  final String name;
  final double amountGrams;
  final double calories;
  final double carbGrams;
  final double fatGrams;
  final double proteinGrams;

  const CreateIngredientRequest(
      {required this.name,
      required this.amountGrams,
      required this.calories,
      required this.carbGrams,
      required this.fatGrams,
      required this.proteinGrams});

  openapi.CreateIngredientRequest toOpenapi() =>
      openapi.CreateIngredientRequest(
        name: name,
        amountGrams: amountGrams,
        calories: calories,
        carbGrams: carbGrams,
        fatGrams: fatGrams,
        proteinGrams: proteinGrams,
      );
}
