import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/atoms/day_display.dart';
import 'package:ui/atoms/time_display.dart';
import 'package:ui/models/workout.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/models/workout.dart' as models;
import 'package:ui/state.dart';
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
    
    context.read<Storage>().getAllWorkouts().then(context.read<AppState>().addWorkouts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
          child: Center(
              child: Consumer<AppState>(builder: (context, state, child) => ListView(
                children: [
                  ...state.workouts().map((w) => WorkoutRow(workout: w))
                ],
              )))),
      bottomNavigationBar: const BottomNav(currentScreen: Screens.exercise),
    );
  }
}

class WorkoutRow extends StatelessWidget {
  final models.Workout workout;

  WorkoutRow({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DayDisplay(date: workout.date),
        TimeDisplay(date: workout.date),
        NeumorphicButton(
          child: const Text("Delete"),
          onPressed: () {
            context.read<Storage>().deleteWorkout(workout.id)
              .then((_) => context.read<AppState>().removeWorkout(workout));
          },
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
