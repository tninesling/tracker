import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/client.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/state.dart';

class MealList extends StatelessWidget {
  final DateTime after;
  final Widget Function(Meal) displayMeal;

  const MealList({Key? key, required this.after, required this.displayMeal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    apiClient
        .getFirstPageOfMeals(after)
        .then(context.read<DietState>().setMeals);

    return Consumer<DietState>(builder: (context, state, child) {
      return ListView.builder(
          itemCount: state.meals().length,
          itemBuilder: (context, index) {
            if (index >= state.meals().length - 1) {
              apiClient.getNextPageOfMeals().then(state.appendMeals);
            }

            return displayMeal(state.meals()[index]);
          });
    });
  }
}
