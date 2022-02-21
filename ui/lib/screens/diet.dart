import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/client.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/molecules/meal_list.dart';
import 'package:ui/state.dart';
import 'package:ui/utils/date_builder.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
        child: Column(
          children: [
            const Indicators(),
            Expanded(
                child: MealList(
              after: DateBuilder().today().dayStart().build(),
              displayMeal: (meal) => MealRow(meal: meal),
            )),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(groupValue: "Diet"),
    );
  }
}

class Indicators extends StatelessWidget {
  const Indicators({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DietState>(builder: (context, state, child) {
      Meal allMeals = state.todaysMeals().fold(Meal.empty(), (all, m) {
        return all.add(m);
      });
      var values = [
        Target(
            name: "Calories",
            value: allMeals.calories,
            targetValue: state.targetCalories()),
        Target(
            name: "Carbs (g)",
            value: allMeals.carbGrams,
            targetValue: state.targetCarbGrams()),
        Target(
            name: "Fat (g)",
            value: allMeals.fatGrams,
            targetValue: state.targetFatGrams()),
        Target(
            name: "Protein (g)",
            value: allMeals.proteinGrams,
            targetValue: state.targetProteinGrams()),
      ];

      return Row(
        children: values,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      );
    });
  }
}

class Target extends StatelessWidget {
  final String name;
  final double value;
  final double targetValue;

  const Target(
      {required this.name, required this.value, required this.targetValue});

  String getName() => name;

  double getPercentCompleted() => value / targetValue;

  double getPercentError() => ((1 - value) / targetValue).abs();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(getName()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CircularProgressIndicator(
            value: getPercentCompleted(),
            color: _selectIndicatorColor(getPercentError()),
            backgroundColor: Colors.grey,
          ),
        ),
        Text("${value.round()} / ${targetValue.round()}"),
      ],
    );
  }

  // TODO soften these colors with some color harmony
  Color _selectIndicatorColor(double percentError) {
    if (percentError < 0.1) {
      return Colors.green.shade300;
    }

    if (percentError < 0.25) {
      return Colors.yellow.shade300;
    }

    return Colors.red.shade300;
  }
}

class MealRow extends StatelessWidget {
  final Meal meal;

  const MealRow({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(meal.id),
        NeumorphicButton(
          child: Text("Delete"),
          onPressed: () {
            apiClient.deleteMeal(meal.id).then((_) {
              context.read<DietState>().removeMeal(meal);
            });
          },
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
