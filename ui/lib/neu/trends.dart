import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/neu/atoms/timeseries.dart';

import '../state.dart';
import 'bottom_nav.dart';

class TrendsScreen extends StatelessWidget {
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
    (m) => TimeseriesPoint(date: m.date, value: m.calories),
    (m) => TimeseriesPoint(date: m.date, value: m.carbGrams),
    (m) => TimeseriesPoint(date: m.date, value: m.fatGrams),
    (m) => TimeseriesPoint(date: m.date, value: m.proteinGrams),
  ];

  @override
  createState() => TrendChartState();
}

class TrendChartState extends State<TrendChart> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Consumer<DietState>(builder: (context, state, child) {
        var mapper = widget.mappers[_selectedIndex];
        return NeumorphicTimeseries(
            timeseriesPoints: state.meals().map(mapper).toList());
      }),
      NeumorphicToggle(
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
      )
    ]);
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
