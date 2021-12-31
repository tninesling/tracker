import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/neu/atoms/scatter_plot.dart';

import '../state.dart';
import 'bottom_nav.dart';

class TrendsScreen extends StatelessWidget {
  const TrendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
          child: Center(child: TrendChart())),
      bottomNavigationBar: const BottomNav(groupValue: "Trends"),
    );
  }
}

class TrendChart extends StatefulWidget {
  final toggles = ["calories", "carbs", "fat", "protein"];
  final mappers = [
    (m) => m.calories,
    (m) => m.carbGrams,
    (m) => m.fatGrams,
    (m) => m.proteinGrams,
  ];

  TrendChart({Key? key}) : super(key: key);

  @override
  createState() => TrendChartState();
}

class TrendChartState extends State<TrendChart> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildChart(),
      _buildToggle(),
    ]);
  }

  Widget _buildChart() {
    return AspectRatio(aspectRatio: 1.7, child: Consumer<DietState>(
      // TODO pass regression line endpoints to plot
      builder: (context, state, child) => ScatterPlot(points: _createPoints(state.meals()))));
  }

  List<Point> _createPoints(List<Meal> meals) {
    var minDate = meals.map((m) => m.date).reduce(_minDate);

    return meals.map((m) => Point(
      x: m.date.difference(minDate).inDays,
      y: widget.mappers[_selectedIndex](m),
    )).toList();
  }

  DateTime _minDate(DateTime d1, DateTime d2) {
    return d1.isBefore(d2) ? d1 : d2;
  }

  Widget _buildToggle() {
    return NeumorphicToggle(
      selectedIndex: _selectedIndex,
      children: widget.toggles.map(_buildToggleElement).toList(),
      thumb: Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(
              const BorderRadius.all(Radius.circular(12))),
        ),
      ),
      onChanged: (v) {
        setState(() {
          _selectedIndex = v;
        });
      },
    );
  }

  ToggleElement _buildToggleElement(String text) {
    return ToggleElement(
      foreground: Center(
          child:
              Text(text, style: const TextStyle(fontWeight: FontWeight.bold))),
      background: Center(
          child: Text(text,
              style: const TextStyle(fontWeight: FontWeight.normal))),
    );
  }
}
