
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:ui/client.dart';
import 'package:ui/create_workout_page.dart';
import 'package:ui/models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // https://pub.dev/packages/beamer#quick-start
  final beamerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) => const HomePage(title: "Home sweet home"),
        '/workouts/new': (context, state, data) => const CreateWorkoutPage()
      }
    ),
    notFoundRedirectNamed: '/',
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
  late Future<List<Workout>> futureWorkouts;


  @override
  void initState() {
    super.initState();
    futureWorkouts = fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<List<Workout>>(
          future: futureWorkouts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('${snapshot.data!.length} workouts');
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return const CircularProgressIndicator();
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.beamToNamed('/workouts/new'),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}