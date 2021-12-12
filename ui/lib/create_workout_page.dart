import 'package:flutter/material.dart';
import 'package:ui/dtos.dart';
import 'package:ui/client.dart';

class CreateWorkoutPage extends StatelessWidget {
  const CreateWorkoutPage({Key? key}) : super(key: key);

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

class WorkoutForm extends StatefulWidget {
  const WorkoutForm({Key? key}) : super(key: key);

  @override
  WorkoutFormState createState() {
    return WorkoutFormState();
  }
}

class WorkoutFormState extends State<WorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          CalendarDatePicker(
            initialDate: date,
            firstDate: DateTime(2021),
            lastDate: DateTime(2099),
            onDateChanged: (newDate) {
              setState(() {
                date = newDate;
              });
            }
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                createNewWorkout(CreateWorkoutDto(date.toUtc(), []));
              }
            },
            child: const Text('Submit'),
          ),
        ]
      )  
    );
  }
}