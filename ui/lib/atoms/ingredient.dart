import 'package:flutter/widgets.dart';
import 'package:ui/models/meal.dart' as models;

class Ingredient extends StatelessWidget {
  final models.Ingredient ingredient;

  Ingredient({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Text(
        "${ingredient.name} | Cals: ${ingredient.calories}, carbs (g) ${ingredient.carbGrams}...");
  }
}
