import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // based on https://docs.flutter.dev/cookbook/forms/validation#2-add-a-textformfield-with-validation-logic
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ]
      )  
    );
  }
}