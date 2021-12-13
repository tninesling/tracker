import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/client.dart';
import 'package:ui/dtos.dart';
import 'package:ui/main.dart';
import 'package:ui/providers/workout_form.dart';

class WorkoutForm extends StatelessWidget {
  const WorkoutForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListView(
        children: <Widget>[
          Consumer<WorkoutFormState>(
            builder: (context, state, child) {
              return CalendarDatePicker(
                initialDate: state.date,
                firstDate: DateTime(2021),
                lastDate: DateTime(2099),
                onDateChanged: state.setDate
              );
            },
          ),
          Consumer<WorkoutFormState>(
            builder: (context, state, child) {
              return Text('${state.exercises.length} exercises');
            }
          ),
          ElevatedButton(
            onPressed: () => context.beamToNamed(MyRoutes.newExercise),
            child: const Text('Add Exercise'),
          ),
          Consumer<WorkoutFormState>(
            builder: (context, state, child) {
              return ElevatedButton(
                onPressed: state.exercises.isEmpty ? null : () {
                  createNewWorkout(CreateWorkoutDto(state.date.toUtc(), state.exercises));
                  state.reset();
                  context.beamBack();
                },
                child: const Text('Submit'),
              );
            },
          )
        ]
      )  
    );
  }
}