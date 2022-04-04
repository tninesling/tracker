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
        .then(context.read<DietState>().addMeals);

    return Consumer<DietState>(builder: (context, state, child) {
      var tm = state.meals().where((m) => m.date.isAfter(after)).toList();
      tm.sort((m1, m2) => m2.date.compareTo(m1.date));

      return ListView.builder(
          itemCount: tm.length,
          itemBuilder: (context, index) {
            if (index >= tm.length - 1) {
              apiClient.getNextPageOfMeals().then(state.addMeals);
            }

            return displayMeal(tm[index]);
          });
    });
  }
}
