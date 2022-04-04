import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/atoms/time_display.dart';
import 'package:ui/client.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/state.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
          child: Indicators()),
      bottomNavigationBar: BottomNav(groupValue: "Diet"),
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
        Target(
          name: "Sugar (g)",
          value: allMeals.sugarGrams,
          targetValue: state.targetSugarGrams(),
        ),
        Target(
          name: "Sodium (mg)",
          value: allMeals.sodiumMilligrams,
          targetValue: state.targetSodiumMilligrams(),
        )
      ];

      return ListView(
        children: values,
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

  double getPercentError() => (1 - getPercentCompleted()).abs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(child: Text(getName()), width: 90),
        SizedBox(child: Text("${value.round()}"), width: 40),
        Expanded(
            child: NeumorphicProgress(
          percent: getPercentCompleted(),
          style: ProgressStyle(
              accent: _selectIndicatorColor(getPercentError()), depth: -1),
        )),
        SizedBox(
            child: Text(
              "${targetValue.round()}",
              textAlign: TextAlign.right,
            ),
            width: 40)
      ],
    );
  }

  // TODO soften these colors with some color harmony
  Color _selectIndicatorColor(double percentError) {
    return Color.lerp(
            Colors.green.shade200, Colors.red.shade200, percentError) ??
        Colors.black;
  }
}

class MealRow extends StatelessWidget {
  final Meal meal;

  const MealRow({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          TimeDisplay(date: meal.date),
          NeumorphicButton(
            child: const Text("Delete"),
            onPressed: () {
              apiClient.deleteMeal(meal.id).then((_) {
                context.read<DietState>().removeMeal(meal);
              });
            },
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
