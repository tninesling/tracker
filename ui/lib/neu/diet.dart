import 'package:charts_flutter/flutter.dart' as charts;
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
          MacroTrendsChart()
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

class Meal {
  final DateTime date;
  final double calories;
  final double carbGrams;
  final double fatGrams;
  final double proteinGrams;

  const Meal(
      {required this.date, required this.calories, required this.carbGrams, required this.fatGrams, required this.proteinGrams});
}

class MacroTrendsChart extends StatefulWidget {
  final toggles = ["calories", "carbs", "fat", "protein"];

  @override
  createState() => MacroTrendsChartState();

  List<charts.Series<Meal, DateTime>> _getSeries() {
    var meals = [
      Meal(date: DateTime(2021, 12, 21, 9), calories: 1287, carbGrams: 85, fatGrams: 20, proteinGrams: 45),
      Meal(date: DateTime(2021, 12, 21, 12), calories: 800, carbGrams: 45, fatGrams: 20, proteinGrams: 45),
      Meal(date: DateTime(2021, 12, 21, 17), calories: 250, carbGrams: 20, fatGrams: 20, proteinGrams: 45),
      Meal(date: DateTime(2021, 12, 22, 11), calories: 650, carbGrams: 55, fatGrams: 20, proteinGrams: 45),
      Meal(date: DateTime(2021, 12, 22, 18), calories: 420, carbGrams: 30, fatGrams: 20, proteinGrams: 45),
      Meal(date: DateTime(2021, 12, 23, 10), calories: 1000, carbGrams: 65, fatGrams: 20, proteinGrams: 45),
      Meal(date: DateTime(2021, 12, 23, 16), calories: 500, carbGrams: 35, fatGrams: 20, proteinGrams: 45),
    ];
    return List.of([
      charts.Series(
          id: "calories",
          data: meals,
          domainFn: (m, _) => m.date,
          measureFn: (m, _) => m.calories),
      charts.Series(
          id: "carbGrams",
          data: meals,
          domainFn: (m, _) => m.date,
          measureFn: (m, _) => m.carbGrams),
      charts.Series(
          id: "fatGrams",
          data: meals,
          domainFn: (m, _) => m.date,
          measureFn: (m, _) => m.fatGrams),
      charts.Series(
          id: "proteinGrams",
          data: meals,
          domainFn: (m, _) => m.date,
          measureFn: (m, _) => m.proteinGrams)
    ]);
  }
}

class MacroTrendsChartState extends State<MacroTrendsChart> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          child: charts.TimeSeriesChart(
              List.of([widget._getSeries()[_selectedIndex]])),
          height: 250,
          width: 500),
      NeumorphicToggle(
        selectedIndex: _selectedIndex,
        children: widget.toggles.map(_buildToggleElement).toList(),
        thumb: Neumorphic(
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.all(Radius.circular(12))),
          ),
        ),
        onChanged: (v) {
          setState(() {
            _selectedIndex = v;
          });
        },
      )
    ]);
  }

  ToggleElement _buildToggleElement(String text) {
    return ToggleElement(
      foreground: Center(
          child: Text(text, style: TextStyle(fontWeight: FontWeight.bold))),
      background: Center(
          child: Text(text, style: TextStyle(fontWeight: FontWeight.normal))),
    );
  }
}
