import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/client.dart';
import 'package:ui/state.dart';

class IngredientList extends StatelessWidget {
  final Widget Function(Ingredient) displayIngredient;

  const IngredientList({Key? key, required this.displayIngredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DietState>(builder: (context, state, child) {
      return ListView.builder(
        itemCount: state.ingredients().length,
        itemBuilder: (context, index) {
          if (index >= state.ingredients().length - 1) {
            apiClient.getNextPageOfIngredients().then(state.appendIngredients);
          }

          return displayIngredient(state.ingredients()[index]);
        },
      );
    });
  }
}
