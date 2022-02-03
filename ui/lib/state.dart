import 'package:flutter/foundation.dart';
import 'package:ui/models/meal.dart';

class DietState with ChangeNotifier {
  double _weightLbs = 160;
  double _targetCalories = 2000;
  List<Ingredient> _ingredients = [];
  List<Meal> _meals = [];

  double targetProteinGrams() => _weightLbs;
  double targetCalories() => _targetCalories;

  double _targetProteinCalories() => targetProteinGrams() * 4;

  double targetCarbGrams() =>
      (targetCalories() - _targetProteinCalories()) / 2 / 9;
  double targetFatGrams() =>
      (targetCalories() - _targetProteinCalories()) / 2 / 4;

  List<Ingredient> ingredients() => _ingredients;
  List<Meal> meals() => _meals;

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

  void setMeals(List<Meal> meals) {
    _meals = meals;
    notifyListeners();
  }
}
