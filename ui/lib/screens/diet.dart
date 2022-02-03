import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/atoms/ingredient.dart';
import 'package:ui/client.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/state.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Make sure this doesn't blow up on failure
    apiClient
        .getFirstPageOfIngredients()
        .then(context.read<DietState>().setIngredients);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 64),
        child: Consumer<DietState>(builder: (context, state, child) {
          return ListView.builder(
            itemCount: state.ingredients().length,
            itemBuilder: (context, index) {
              if (index >= state.ingredients().length - 1) {
                apiClient
                    .getNextPageOfIngredients()
                    .then(state.appendIngredients);
              }
              return Ingredient(ingredient: state.ingredients()[index]);
            },
          );
        }),
      ),
      bottomNavigationBar: const BottomNav(groupValue: "Diet"),
    );
  }
}

class Indicators extends StatelessWidget {
  final DietState state;

  Indicators({required this.state});

  @override
  Widget build(BuildContext context) {
    final values = [
      Target(
          name: "Calories", value: 1540, targetValue: state.targetCalories()),
      Target(
          name: "Carbs (g)", value: 100, targetValue: state.targetCarbGrams()),
      Target(name: "Fat (g)", value: 83, targetValue: state.targetFatGrams()),
      Target(
          name: "Protein (g)",
          value: 72,
          targetValue: state.targetProteinGrams()),
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: values
              .map((v) => Column(children: [
                    NeumorphicIndicator(
                        percent: v.getPercentCompleted(),
                        height: 100,
                        width: 20,
                        style: IndicatorStyle(
                          variant: _selectIndicatorColor(
                              v.getPercentError()), // Colors.indigo.shade300,
                          accent: _selectIndicatorColor(
                              v.getPercentError()), // Colors.indigo.shade300,
                        )),
                    Text(v.getName().characters.first),
                  ]))
              .toList()),
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

class Target {
  final String name;
  final double value;
  final double targetValue;

  const Target(
      {required this.name, required this.value, required this.targetValue});

  String getName() => name;

  double getPercentCompleted() => value / targetValue;

  double getPercentError() => 1 - getPercentCompleted();
}
