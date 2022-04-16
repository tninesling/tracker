import 'package:flutter/foundation.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/utils/date_builder.dart';

class AppState with ChangeNotifier {
  final MealSet _meals = MealSet();

  double _weightLbs = 160;
  double _targetCalories = 2000;
  List<Ingredient> _ingredients = [];

  double targetProteinGrams() => _weightLbs;
  double targetCalories() => _targetCalories;

  double _targetProteinCalories() => targetProteinGrams() * 4;

  double targetCarbGrams() =>
      (targetCalories() - _targetProteinCalories()) / 2 / 9;
  double targetFatGrams() =>
      (targetCalories() - _targetProteinCalories()) / 2 / 4;

  double targetSugarGrams() => 10;
  double targetSodiumMilligrams() => 500;

  List<Ingredient> ingredients() => _ingredients;
  MealSet meals() => _meals;

  // Abstract weight like Duration is done
  void setWeightLbs(double w) {
    _weightLbs = w;
    notifyListeners();
  }

  void setTargetCalories(double tc) {
    _targetCalories = tc;
    notifyListeners();
  }

  void setIngredients(Iterable<Ingredient> ingredients) {
    _ingredients = ingredients.toList();
    notifyListeners();
  }

  void appendIngredients(Iterable<Ingredient> ingredients) {
    _ingredients.addAll(ingredients);
    notifyListeners();
  }

  void addMeals(Iterable<Meal> meals) {
    _meals.addAll(meals);
    notifyListeners();
  }

  void removeMeal(Meal meal) {
    _meals.remove(meal);
    notifyListeners();
  }

  Iterable<Meal> todaysMeals() => meals()
      .where((m) => m.date.isAfter(DateBuilder().today().dayStart().build()));
  
  Iterable<Meal> mealsOnDay(DateTime date) => meals().where((m) =>
      m.date.year == date.year &&
      m.date.month == date.month &&
      m.date.day == date.day);
}
