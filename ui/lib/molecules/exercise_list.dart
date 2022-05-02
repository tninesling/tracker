import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/models/workout.dart';
import 'package:ui/storage.dart';
import 'package:ui/state.dart';

class ExerciseList extends StatefulWidget {
  final Widget Function(Exercise) displayExercise;

  const ExerciseList({Key? key, required this.displayExercise})
      : super(key: key);

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  List<Exercise> exercises = [];

  @override
  void initState() {
    super.initState();
    exercises = [];

    context.read<Storage>().getFirstPageOfExercises().then((es) {
      setState(() {
        exercises.addAll(es);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, child) {
      return ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          if (index >= exercises.length - 1) {
            context.read<Storage>().getNextPageOfExercises().then((es) {
              setState(() {
                exercises.addAll(es);
              });
            });
          }

          return widget.displayExercise(exercises.elementAt(index));
        },
      );
    });
  }
}
