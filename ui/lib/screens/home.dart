import 'package:beamer/beamer.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ui/client.dart';
import 'package:ui/data/daily_workout_summary.dart';
import 'package:ui/main.dart';
import 'package:ui/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<List<Workout>> workouts;

  @override
  void initState() {
    super.initState();
    workouts = getAllWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const WorkoutWeightsBarChart(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.beamToNamed(MyRoutes.newWorkout),
        tooltip: 'Create New Workout',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class WorkoutWeightsBarChart extends StatefulWidget {
  const WorkoutWeightsBarChart({Key? key}) : super(key: key);

  @override
  State<WorkoutWeightsBarChart> createState() => WorkoutWeightsBarChartState();
}

class WorkoutWeightsBarChartState extends State<WorkoutWeightsBarChart> {
  late Future<List<DailyWorkoutSummary>> summaries;

  @override
  void initState() {
    super.initState();
    summaries = getWorkoutSummaries();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DailyWorkoutSummary>>(
      future: summaries,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        
        snapshot.data!.sort((a, b) => a.date.compareTo(b.date));
        
        // https://google.github.io/charts/flutter/example/bar_charts/simple
        return BarChart([
          Series<DailyWorkoutSummary, String>(
            id: 'WorkoutSummaries',
            data: snapshot.data!,
            domainFn: (summary, _) => DateFormat('yyyy-MM-dd').format(summary.date),
            measureFn: (summary, _) => summary.totalWeightKg,
          )
        ]);
      }
    );
  }
}