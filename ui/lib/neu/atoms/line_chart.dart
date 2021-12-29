import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class Point {
  final double x;
  final double y;

  Point({required this.x, required this.y});
}

class NeumorphicLineChart extends StatelessWidget {
  final List<Point> points;

  NeumorphicLineChart({required this.points});

  @override
  Widget build(BuildContext context) {
    return _buildContainer(_buildChart(context));
  }

  Widget _buildContainer(Widget chart) {
    return Neumorphic(
        child: AspectRatio(
            aspectRatio: 1.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: chart,
            )),
        style: NeumorphicStyle(depth: -2));
  }

  Widget _buildChart(BuildContext context) {
    return LineChart(LineChartData(
        lineBarsData: [
          LineChartBarData(
              spots: points.map((p) => FlSpot(p.x, p.y)).toList(),
              isCurved: true,
              preventCurveOverShooting: true,
              dotData: FlDotData(show: false),
              colors: [Colors.black],
              belowBarData: BarAreaData(show: true, colors: [Colors.black]))
        ],
        minY: points.fold<double>(0, (m, p) => min(m, p.y)),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false)));
  }
}
