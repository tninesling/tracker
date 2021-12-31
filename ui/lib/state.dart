import 'package:flutter/foundation.dart';

class DietState with ChangeNotifier {
  double _weightLbs = 160;
  double _targetCalories = 2000;

  double targetProteinGrams() => _weightLbs;
  double targetCalories() => _targetCalories;

  double _targetProteinCalories() => targetProteinGrams() * 4;

  double targetCarbGrams() =>
      (targetCalories() - _targetProteinCalories()) / 2 / 9;
  double targetFatGrams() =>
      (targetCalories() - _targetProteinCalories()) / 2 / 4;

  List<Meal> meals() => [
      Meal(date: DateTime(2021, 12, 21, 9), calories: 2100, carbGrams: 85, fatGrams: 20, proteinGrams: 45),
      Meal(date: DateTime(2021, 12, 22, 12), calories: 2200, carbGrams: 45, fatGrams: 14, proteinGrams: 20),
      Meal(date: DateTime(2021, 12, 23, 17), calories: 2058, carbGrams: 20, fatGrams: 42, proteinGrams: 62),
      Meal(date: DateTime(2021, 12, 24, 11), calories: 2145, carbGrams: 55, fatGrams: 18, proteinGrams: 14),
      Meal(date: DateTime(2021, 12, 27, 18), calories: 2008, carbGrams: 30, fatGrams: 27, proteinGrams: 52),
      Meal(date: DateTime(2021, 12, 28, 10), calories: 2340, carbGrams: 65, fatGrams: 32, proteinGrams: 31),
      Meal(date: DateTime(2021, 12, 31, 16), calories: 1980, carbGrams: 35, fatGrams: 14, proteinGrams: 23),
    ];
      
  // Abstract weight like Duration is done
  void setWeightLbs(double w) {
    _weightLbs = w;
    notifyListeners();
  }

  void setTargetCalories(double tc) {
    _targetCalories = tc;
    notifyListeners();
  }
}

class Meal {
  final DateTime date;
  final double calories;
  final double carbGrams;
  final double fatGrams;
  final double proteinGrams;

  const Meal(
      {required this.date, required this.calories, required this.carbGrams, required this.fatGrams, required this.proteinGrams});
}
