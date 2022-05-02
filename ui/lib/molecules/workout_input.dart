import 'dart:collection';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/storage.dart';
import 'package:ui/models/workout.dart';
import 'package:ui/molecules/amount_form.dart';
import 'package:ui/molecules/datetime_input.dart';
import 'package:ui/molecules/exercise_selector.dart';

enum WorkoutInputStage {
  pickDateTime,
  pickExercise,
  pickExerciseAmount,
}

class WorkoutInput extends StatefulWidget {
  final Function(CreateWorkoutRequest) onSubmit;

  const WorkoutInput({Key? key, required this.onSubmit}) : super(key: key);

  @override
  WorkoutInputState createState() => WorkoutInputState();
}

class WorkoutInputState extends State<WorkoutInput> {
  DateTime? date;
  Exercise? exercise;
  double? amount;
  Map<Exercise, double> exerciseAmounts;
  Map<Exercise, int> exerciseOrder;

  WorkoutInputState()
      : exerciseAmounts = HashMap(
            equals: (i1, i2) => i1.id == i2.id, hashCode: (i) => i.id.hashCode),
        exerciseOrder = HashMap(
            equals: (i1, i2) => i1.id == i2.id, hashCode: (i) => i.id.hashCode);

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return DateTimeInput(onChanged: (pickedDate) {
        setState(() {
          date = pickedDate;
        });
      });
    }

    if (exercise == null) {
      return ExerciseSelector(onSelected: (selected) {
        setState(() {
          exercise = selected;
          exerciseOrder[selected] = exerciseOrder.length;
        });
      });
    }

    if (amount == null) {
      // TODO: Parameterize unit string
      return AmountForm(onSubmit: (newAmount) {
        setState(() {
          amount = newAmount;
          exerciseAmounts[exercise!] = newAmount;
        });
      });
    }

    return ListView(children: [
      ...exerciseAmounts.entries.map((entry) {
        return Row(
          children: [
            Expanded(child: Text("${entry.key.name}")),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  amount = null;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                var exerciseToRemove = entry.key;
                setState(() {
                  exerciseAmounts.remove(exerciseToRemove);
                  exerciseOrder.remove(exerciseToRemove);
                  exerciseOrder = exerciseOrder.map((exercise, order) =>
                      MapEntry(exercise,
                          order < exerciseToRemove.order ? order : order - 1));
                });
              },
            ),
          ],
        );
      }),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeumorphicButton(
                child: const Text("Add Exercise"),
                onPressed: () {
                  setState(() {
                    exercise = null;
                    amount = null;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<Storage>(
                builder: (context, storage, child) => NeumorphicButton(
                    child: const Text("Submit"),
                    onPressed: () {
                      widget.onSubmit(CreateWorkoutRequest(
                        date: date!,
                        exerciseAmounts: exerciseAmounts.map(
                            (exercise, amount) =>
                                MapEntry(exercise.id, amount)),
                        exerciseOrder: exerciseOrder.map(
                            (exercise, order) => MapEntry(exercise.id, order)),
                      ));
                    }),
              ),
            ),
          )
        ],
      ),
    ]);
  }
}
