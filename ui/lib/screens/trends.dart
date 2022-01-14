import 'dart:math';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/client.dart';
import 'package:ui/atoms/scatter_plot.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/models/trend.dart';

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
  final toggles = ["carbs", "fat", "protein"];

  TrendChart({Key? key}) : super(key: key);

  @override
  createState() => TrendChartState();
}

class TrendChartState extends State<TrendChart> {
  late int selectedIndex;
  late Future<Map<String, Trend>> trends;

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    trends = getMacroTrends();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildChart(),
      _buildToggle(),
    ]);
  }

  Widget _buildChart() {
    return AspectRatio(aspectRatio: 1.7, child: FutureBuilder<Map<String, Trend>>(
      future: trends,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        
        // TODO Configure other macros and remove second !
        var macro = widget.toggles[selectedIndex];
        var trend = snapshot.data![macro];
        var points = trend?.points ?? [];
        double minX = points.fold(double.infinity, (acc, p) => min(acc, p.x));
        double maxX = points.fold(double.negativeInfinity, (acc, p) => max(acc, p.x));

        return ScatterPlot(
          points: points,
          regressionLineEndpoints: trend == null ? [] : [
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
