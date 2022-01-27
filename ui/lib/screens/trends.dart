import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:openapi/api.dart';
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

// TODO integrate generated client
class TrendChart extends StatefulWidget {
  final toggles = ["macros", "weight"];
  final fetchCalls = [
    getMacroTrends,
    getWeightTrends,
  ];

  TrendChart({Key? key}) : super(key: key);

  @override
  createState() => TrendChartState();
}

class TrendChartState extends State<TrendChart> {
  late int selectedIndex;
  late Future<Iterable<Trend>> trends;

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
    return AspectRatio(
        aspectRatio: 1.7,
        child: FutureBuilder<Iterable<Trend>>(
            future: trends,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              var trends = snapshot.data!;

              return ScatterPlot(trends: trends);
            }));
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
          trends = widget.fetchCalls[v]();
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
