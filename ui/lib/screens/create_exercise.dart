import 'package:flutter/material.dart';
import 'package:ui/forms/exercise.dart';

class CreateExerciseScreen extends StatelessWidget {
  const CreateExerciseScreen({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Exercise!"),
      ),
      body: const Center(
        child: ExerciseForm(),
      )
    );
  }
}