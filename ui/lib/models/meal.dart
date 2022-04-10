import 'package:openapi/api.dart' as openapi;
import 'package:uuid/uuid.dart';

class Meal {
  final String id;
  final DateTime date;
  final List<Ingredient> ingredients;
  late final double calories;
  late final double carbGrams;
  late final double fatGrams;
  late final double proteinGrams;
  late final double sugarGrams;
  late final double sodiumMilligrams;

  Meal({required this.id, required this.date, required this.ingredients}) {
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
    sugarGrams = ingredients.fold(0.0, (acc, i) {
      return acc + i.sugarGrams;
    });
    sodiumMilligrams = ingredients.fold(0.0, (acc, i) {
      return acc + i.sodiumMilligrams;
    });
  }

  factory Meal.empty() => Meal(id: '', date: DateTime.now(), ingredients: []);

  factory Meal.fromOpenapi(openapi.Meal m) => Meal(
        id: m.id,
        date: m.date,
        ingredients: m.ingredients.map(Ingredient.fromOpenapi).toList(),
      );

  Meal add(Meal other) => Meal(
        id: '',
        date: date,
        ingredients: [...ingredients, ...other.ingredients],
      );
}

class MealSet extends Iterable<Meal> {
  final Set<String> _ids = {};
  final List<Meal> _meals = [];

  MealSet({Iterable<Meal>? meals}) {
    if (meals != null) {
      addAll(meals);
    }
  }

  void addAll(Iterable<Meal> ms) {
    for (Meal m in ms) {
      if (!_ids.contains(m.id)) {
        _ids.add(m.id);
        _meals.add(m);
      }
    }
  }

  void remove(Meal m) {
    _ids.remove(m.id);
    _meals.remove(m);
  }

  @override
  Iterator<Meal> get iterator => _meals.iterator;
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
  final double sugarGrams;
  final double sodiumMilligrams;

  const Ingredient(
      {required this.id,
      required this.name,
      required this.amountGrams,
      required this.calories,
      required this.carbGrams,
      required this.fatGrams,
      required this.proteinGrams,
      required this.sugarGrams,
      required this.sodiumMilligrams});

  factory Ingredient.fromCreateRequest(CreateIngredientRequest i) => Ingredient(
        id: const Uuid().v4(),
        name: i.name,
        amountGrams: i.amountGrams,
        calories: i.calories,
        carbGrams: i.carbGrams,
        fatGrams: i.fatGrams,
        proteinGrams: i.proteinGrams,
        sugarGrams: i.sugarGrams,
        sodiumMilligrams: i.sodiumMilligrams,
      );

  factory Ingredient.fromMap(Map<String, dynamic> map) => Ingredient(
        id: map['id'],
        name: map['name'],
        amountGrams: map['amountGrams'],
        calories: map['calories'],
        carbGrams: map['carbGrams'],
        fatGrams: map['fatGrams'],
        proteinGrams: map['proteinGrams'],
        sugarGrams: map['sugarGrams'],
        sodiumMilligrams: map['sodiumMilligrams'],
      );

  factory Ingredient.fromOpenapi(openapi.Ingredient i) => Ingredient(
        id: i.id,
        name: i.name,
        amountGrams: i.amountGrams,
        calories: i.calories,
        carbGrams: i.carbGrams,
        fatGrams: i.fatGrams,
        proteinGrams: i.proteinGrams,
        sugarGrams: i.sugarGrams,
        sodiumMilligrams: i.sodiumMilligrams,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amountGrams': amountGrams,
      'calories': calories,
      'carbGrams': carbGrams,
      'fatGrams': fatGrams,
      'proteinGrams': proteinGrams,
      'sugarGrams': sugarGrams,
      'sodiumMilligrams': sodiumMilligrams,
    };
  }
}

class CreateIngredientRequest {
  final String name;
  final double amountGrams;
  final double calories;
  final double carbGrams;
  final double fatGrams;
  final double proteinGrams;
  final double sugarGrams;
  final double sodiumMilligrams;

  const CreateIngredientRequest(
      {required this.name,
      required this.amountGrams,
      required this.calories,
      required this.carbGrams,
      required this.fatGrams,
      required this.proteinGrams,
      required this.sugarGrams,
      required this.sodiumMilligrams});

  openapi.CreateIngredientRequest toOpenapi() =>
      openapi.CreateIngredientRequest(
        name: name,
        amountGrams: amountGrams,
        calories: calories,
        carbGrams: carbGrams,
        fatGrams: fatGrams,
        proteinGrams: proteinGrams,
        sugarGrams: sugarGrams,
        sodiumMilligrams: sodiumMilligrams,
      );
}
