import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/providers/workout_form.dart';
import 'package:ui/screens/create_exercise.dart';
import 'package:ui/screens/create_workout.dart';
import 'package:ui/screens/home.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutFormState())
      ],
      child: MyApp()
    )
  );
}

class MyRoutes {
  static String get home => '/';
  static String get newExercise => '/exercises/new';
  static String get newWorkout => '/workouts/new';
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // https://pub.dev/packages/beamer#quick-start
  final beamerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        MyRoutes.home: (context, state, data) => const HomeScreen(title: "Home sweet home"),
        MyRoutes.newExercise: (context, state, data) => const CreateExerciseScreen(),
        MyRoutes.newWorkout: (context, state, data) => const CreateWorkoutScreen()
      }
    ),
    notFoundRedirectNamed: MyRoutes.home,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: beamerDelegate,
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: beamerDelegate),
    );
  }
}