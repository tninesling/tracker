import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/storage.dart';
import 'package:ui/state.dart';

class IngredientList extends StatelessWidget {
  final Widget Function(Ingredient) displayIngredient;

  const IngredientList({Key? key, required this.displayIngredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    context
        .read<Storage>()
        .getFirstPageOfIngredients()
        .then(context.read<AppState>().addIngredients);

    return Consumer<AppState>(builder: (context, state, child) {
      return ListView.builder(
        itemCount: state.ingredients().length,
        itemBuilder: (context, index) {
          if (index >= state.ingredients().length - 1) {
            context
                .read<Storage>()
                .getNextPageOfIngredients()
                .then(state.addIngredients);
          }

          return displayIngredient(state.ingredients().elementAt(index));
        },
      );
    });
  }
}
