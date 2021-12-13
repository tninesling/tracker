import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/dtos.dart';
import 'package:ui/providers/workout_form.dart';

class ExerciseForm extends StatefulWidget {
  const ExerciseForm({Key? key}) : super(key: key);

  @override
  ExerciseFormState createState() {
    return ExerciseFormState();
  }
}

class ExerciseFormState extends State<ExerciseForm> {
  final _formKey = GlobalKey<FormState>();

  late String name;
  late String reps;
  late String sets;
  late String weightKg;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            onChanged: (text) {
              setState(() {
                name = text;
              });
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter number of reps';
              }
              return null;
            },
            onChanged: (text) {
              setState(() {
                reps = text;
              });
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please number of sets';
              }
              return null;
            },
            onChanged: (text) {
              setState(() {
                sets = text;
              });
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a weight';
              }
              return null;
            },
            onChanged: (text) {
              setState(() {
                weightKg = text;
              });
            },
          ),
          Consumer<WorkoutFormState>(
            builder:(context, state, child) {
              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    state.addExercise(
                      CreateExerciseDto(
                        name,
                        int.parse(reps),
                        int.parse(sets),
                        double.parse(weightKg)
                      )
                    );
                    context.beamBack();
                  }
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