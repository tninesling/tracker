import 'dart:math';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/client.dart';
import 'package:ui/neu/atoms/scatter_plot.dart';
import 'package:ui/neu/bottom_nav.dart';
import 'package:ui/neu/models/trend.dart';

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
  final fetchCalls = [
    getCalorieTrend,
    getCarbsTrend,
    getFatTrend,
    getProteinTrend,
  ];

  TrendChart({Key? key}) : super(key: key);

  @override
  createState() => TrendChartState();
}

class TrendChartState extends State<TrendChart> {
  late int selectedIndex;
  late Future<Trend> trend;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    trend = getCalorieTrend();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildChart(),
      _buildToggle(),
    ]);
  }

  Widget _buildChart() {
    return AspectRatio(aspectRatio: 1.7, child: FutureBuilder<Trend>(
      future: trend,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        var trend = snapshot.data!;
        double minX = trend.points.fold(double.infinity, (acc, p) => min(acc, p.x));
        double maxX = trend.points.fold(double.negativeInfinity, (acc, p) => max(acc, p.x));

        return ScatterPlot(
          points: trend.points,
          regressionLineEndpoints: [
            trend.line.pointAt(minX),
            trend.line.pointAt(maxX),
          ],
        );
      }
    ));
  }

  Widget _buildToggle() {
    return NeumorphicToggle(
      selectedIndex: selectedIndex,
      children: widget.toggles.map(_buildToggleElement).toList(),
      thumb: Neumorphic(
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(
              const BorderRadius.all(Radius.circular(12))),
        ),
      ),
      onChanged: (v) {
        setState(() {
          selectedIndex = v;
          trend = widget.fetchCalls[v]();
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
