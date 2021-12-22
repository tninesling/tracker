import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyRoutes {
  static String get home => '/';
  static String get newExercise => '/exercises/new';
  static String get newWorkout => '/workouts/new';
}


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'Heath',
      themeMode: ThemeMode.light,
      // Color palettes: https://api.flutter.dev/flutter/material/Colors-class.html
      theme: NeumorphicThemeData(
        baseColor: Colors.indigo.shade100,
        depth: 2,
        lightSource: LightSource.topLeft,
        iconTheme: IconThemeData(
          color: Colors.indigo.shade300,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            color: Colors.indigo.shade900,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: Colors.indigo.shade800,
            fontSize: 24,
          ),
          bodyText1: TextStyle(
            color: Colors.indigo.shade300,
            fontSize: 16,
          )
        )
      ),
      darkTheme: const NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        defaultTextColor: Color(0xFFFFFFFF),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      floatingActionButton: const NewWorkoutButton(),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  child: Text(
                    "Hey!\nIt's time to work out.",
                    style: NeumorphicTheme.currentTheme(context).textTheme.headline1
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                ),
                Container(
                  child: Text(
                    "Here's today's plan",
                    style: NeumorphicTheme.currentTheme(context).textTheme.headline2,  
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 16)
                ),
                const ExerciseCard(exercise: "Deadlift: 5x5 @ 210lbs"),
                const ExerciseCard(exercise: "Overhead Press: 5x5 @ 70lbs"),
                const ExerciseCard(exercise: "Leg Curls: 5x10 @ 110lbs"),
                const ExerciseCard(exercise: "Leg Extensions: 5x10 @ 110lbs"),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            RotatedBox(
              child: NeumorphicText(
                "EXERCISE",
                style: const NeumorphicStyle(
                  depth: 1,
                  intensity: 0.6,
                  lightSource: LightSource.bottomLeft
                ),
                textStyle: NeumorphicTextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
              quarterTurns: 1,
            )
          ]
        )
      )
    );
  }
}

class NewWorkoutButton extends StatelessWidget {
  const NewWorkoutButton({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicFloatingActionButton(
      child: const Center(
        child: Icon(
          Icons.fitness_center_rounded,
          size: 30,
        )
      ),
      onPressed: () {
        Fluttertoast.showToast(msg: "Pressed");
      },
      style: NeumorphicStyle(
        color: NeumorphicTheme.baseColor(context),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String exercise;

  const ExerciseCard({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Text(
        exercise,
        style: NeumorphicTheme.currentTheme(context).textTheme.bodyText1,
      ),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}