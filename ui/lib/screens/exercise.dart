import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/atoms/day_display.dart';
import 'package:ui/atoms/header.dart';
import 'package:ui/atoms/loader.dart';
import 'package:ui/atoms/square_icon_button.dart';
import 'package:ui/atoms/time_display.dart';
import 'package:ui/models/workout.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/models/workout.dart' as models;
import 'package:ui/molecules/screen.dart';
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

    context
        .read<Storage>()
        .getAllWorkouts()
        .then(context.read<AppState>().addWorkouts);
  }

  @override
  Widget build(BuildContext context) => Screen(
        body: Consumer<AppState>(builder: (context, state, child) {
          var workoutKey =
              state.workoutsSortedByDateDesc().map((w) => w.id).join();
          return ListView(
            children: [
              const Header("Summary"),
              WorkoutsSummary(key: ValueKey(workoutKey)),
              const Divider(),
              const Header("Workouts"),
              ...state.workoutsSortedByDateDesc().map(WorkoutRow.fromModel)
            ],
          );
        }),
        screen: Screens.exercise,
      );
}

class WorkoutsSummary extends StatefulWidget {
  const WorkoutsSummary({Key? key}) : super(key: key);

  @override
  State<WorkoutsSummary> createState() => _WorkoutsSummaryState();
}

class _WorkoutsSummaryState extends State<WorkoutsSummary> {
  late Future<Iterable<ExerciseReference>> mostWeightMovedPerExercise;

  @override
  void initState() {
    super.initState();
    mostWeightMovedPerExercise =
        context.read<Storage>().getMostWeightMovedPerExercise();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<ExerciseReference>>(
        future: mostWeightMovedPerExercise,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return Loader();
          }

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: snapshot.data!
                  .map((e) => Text("${e.name}: ${e.amount}${e.unit}"))
                  .toList());
        });
  }
}

class WorkoutRow extends StatelessWidget {
  final models.Workout workout;

  const WorkoutRow({Key? key, required this.workout}) : super(key: key);

  factory WorkoutRow.fromModel(models.Workout workout) =>
      WorkoutRow(workout: workout);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          DayDisplay(date: workout.date),
          TimeDisplay(date: workout.date),
          SquareIconButton(
            icon: Icons.delete,
            onPressed: () {
              context
                  .read<Storage>()
                  .deleteWorkout(workout.id)
                  .then((_) => context.read<AppState>().removeWorkout(workout));
            },
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
