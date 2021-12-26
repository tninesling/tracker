import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/neu/exercise.dart';
import 'package:ui/state.dart';

class MyRoutes {
  static String get home => '/';
  static String get newExercise => '/exercises/new';
  static String get newWorkout => '/workouts/new';
}


void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DietState())
      ],
      child: MyApp()
    ));

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
        depth: 1,
        lightSource: LightSource.topLeft,
        intensity: 4,
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
      darkTheme: NeumorphicThemeData(
        baseColor: Colors.indigo.shade300,
        depth: 1,
        lightSource: LightSource.topLeft,
        defaultTextColor: Colors.white,
        intensity: 4,
        iconTheme: IconThemeData(
          color: Colors.indigo.shade100,
        ),
        textTheme: TextTheme(
          headline1: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headline2: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
          bodyText1: TextStyle(
            color: Colors.indigo.shade100,
            fontSize: 16,
          )
        )
      ),
      home: const ExerciseScreen(),
    );
  }
}