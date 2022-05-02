import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/models/workout.dart';

class ExerciseInput extends StatefulWidget {
  final Function(CreateExerciseRequest) onSubmit;

  const ExerciseInput({required this.onSubmit});

  @override
  State<ExerciseInput> createState() => _ExerciseInputState();
}

class _ExerciseInputState extends State<ExerciseInput> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String unit;
  late int amount;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid name';
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Unit'),
            onChanged: (value) {
              setState(() {
                unit = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid unit';
              }
            },
          ),
          NeumorphicButton(
            child: const Text("Submit"),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(CreateExerciseRequest(name: name, unit: unit));
              }
            },
          )
        ]));
  }
}
