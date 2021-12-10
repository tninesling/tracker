import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Workout {
  final String date;

  Workout({
    required this.date,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      date: json['date'],
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late Future<List<Workout>> futureWorkouts;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<List<Workout>> fetchWorkouts() async {
    const localhostIP = '10.0.2.2';
    final response = await http.get(Uri.parse('http://$localhostIP:8080/workouts'));

    if (response.statusCode == 200) {
      final List<dynamic> workouts = jsonDecode(response.body);

      return workouts.map((dyn) => Workout.fromJson(dyn)).toList();
    } else {
      throw Exception("Poopy stinky");
    }
  }
}
