import 'dart:collection';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/atoms/integer_input.dart';
import 'package:ui/atoms/square_icon_button.dart';
import 'package:ui/storage.dart';
import 'package:ui/models/workout.dart';
import 'package:ui/molecules/amount_form.dart';
import 'package:ui/molecules/datetime_input.dart';
import 'package:ui/molecules/exercise_selector.dart';

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
  int? reps;
  List<ExerciseReference> exercises;

  WorkoutInputState() : exercises = [];

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
        });
      });
    }

    if (amount == null) {
      return AmountForm(
          unit: exercise!.unit(),
          onSubmit: (newAmount) {
            setState(() {
              amount = newAmount;
              exercises.add(ExerciseReference(
                  exerciseId: exercise!.id,
                  name: exercise!.name,
                  unit: exercise!.unit(),
                  order: exercises.length,
                  amount: newAmount));
            });
          });
    }

    // TODO: Repetition input for exercises where isRepeated() == true
    // as well as a rollup to show counts in rows instead of all repetitions

    return ListView(children: [
      const Text("Exercises",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ...exercises.map((e) {
        return ExerciseRow(
          exercise: e,
          onEdit: () {
            setState(() {
              amount = null;
            });
          },
          onDelete: () {
            setState(() {
              for (var i = e.order + 1; i < exercises.length; i++) {
                exercises[i].order--;
              }
              exercises.removeAt(e.order);
            });
          },
        );
      }),
      Row(
        children: [
          Expanded(
            child: AddExerciseButton(
              onPressed: () {
                setState(() {
                  exercise = null;
                  amount = null;
                });
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: SubmitButton(onPressed: () {
              widget.onSubmit(CreateWorkoutRequest(
                date: date!,
                exercises: exercises,
              ));
            }),
          )
        ],
      ),
    ]);
  }
}

class ExerciseRow extends StatelessWidget {
  final ExerciseReference exercise;
  final Function() onEdit;
  final Function() onDelete;

  const ExerciseRow(
      {Key? key,
      required this.exercise,
      required this.onEdit,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(exercise.name),
        Text("${exercise.amount} (${exercise.unit})"),
        SquareIconButton(
          icon: Icons.edit,
          onPressed: onEdit,
        ),
        SquareIconButton(
          icon: Icons.delete,
          onPressed: onDelete,
        ),
      ],
    );
  }
}

class AddExerciseButton extends StatelessWidget {
  final Function() onPressed;

  AddExerciseButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      NeumorphicButton(child: const Text("Add Exercise"), onPressed: onPressed);
}

class SubmitButton extends StatelessWidget {
  final Function() onPressed;

  SubmitButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      NeumorphicButton(child: const Text("Submit"), onPressed: onPressed);
}
