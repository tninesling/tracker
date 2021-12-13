import 'package:flutter/material.dart';
import 'package:ui/forms/workout.dart';

class CreateWorkoutScreen extends StatelessWidget {
  const CreateWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Workout!"),
      ),
      body: const Center(
        child: WorkoutForm(),
      )
    );
  }
}
