import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/neu/bottom_nav.dart';

import '../state.dart';
import 'basic.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 64),
        child: Column(children: [
          const TextFromTheDepths(text: "Eat something?"),
          Consumer<DietState>(builder: (context, state, child) {
            return _buildIndicators(context, state);
          }),
        ]),
      ),
      bottomNavigationBar: const BottomNav(groupValue: "Diet"),
    );
  }

  Widget _buildIndicators(BuildContext context, DietState state) {
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