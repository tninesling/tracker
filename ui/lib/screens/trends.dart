import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/atoms/scatter_plot.dart';
import 'package:ui/models/trend.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/storage.dart';

class TrendsScreen extends StatelessWidget {
  const TrendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
          child: Center(child: TrendChart())),
      bottomNavigationBar: BottomNav(groupValue: "Trends"),
    );
  }
}

class TrendChart extends StatefulWidget {
  const TrendChart({Key? key}) : super(key: key);

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
    trends = context
        .read<Storage>()
        .getMacroTrends(DateTime.now().subtract(const Duration(days: 30)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<Trend>>(
      future: trends,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        var trends = snapshot.data!.toList();
        return ListView(
          children: trends.expand((trend) => [
            Text(trend.name),
            AspectRatio(
              aspectRatio: 1.7,
              child: ScatterPlot(trends: [trend]),
            )
          ]).toList()
        );
      });
  }
}
