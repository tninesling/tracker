
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:ui/client.dart';
import 'package:ui/create_workout_page.dart';
import 'package:ui/models.dart';

void main() {
  runApp(MyApp());
}

class MyRoutes {
  static String get home => '/';
  static String get newWorkout => '/workouts/new';
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // https://pub.dev/packages/beamer#quick-start
  final beamerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        MyRoutes.home: (context, state, data) => const HomePage(title: "Home sweet home"),
        MyRoutes.newWorkout: (context, state, data) => const CreateWorkoutPage()
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

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Future<List<Workout>> workouts;

  @override
  void initState() {
    super.initState();
    workouts = getAllWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Workout>>(
          future: workouts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.map((w) => w.toJson()).join("\n"));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.beamToNamed(MyRoutes.newWorkout),
        tooltip: 'Create New Workout',
        child: const Icon(Icons.add),
      ),
    );
  }
}