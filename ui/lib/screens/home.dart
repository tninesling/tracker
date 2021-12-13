import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:ui/client.dart';
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
      body: Center(
        child: FutureBuilder<List<Workout>>(
          future: workouts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.map((w) => w.toJson()).join("\n"));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.beamToNamed(MyRoutes.newWorkout),
        tooltip: 'Create New Workout',
        child: const Icon(Icons.add),
      ),
    );
  }
}