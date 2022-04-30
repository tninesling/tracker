import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/models/exercise.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/models/exercise.dart' as models;
import 'package:ui/storage.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late Future<Iterable<Workout>> workouts;

  @override
  void initState() {
    super.initState();
    workouts = context.read<Storage>().getAllWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
          child: Center(
              child: FutureBuilder<Iterable<Workout>>(
                  future: workouts,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }

                    if (!snapshot.hasData) {
                      return const Text("Loading");
                    }

                    return ListView(
                      children: snapshot.data!
                          .map((w) => WorkoutRow(
                                workout: w,
                              ))
                          .toList(),
                    );
                  }))),
      bottomNavigationBar: const BottomNav(currentScreen: Screens.exercise),
    );
  }
}

class WorkoutRow extends StatelessWidget {
  final models.Workout workout;

  WorkoutRow({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Text(workout.id);
  }
}
