import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ui/models.dart';

Future<List<Workout>> fetchWorkouts() async {
    const localhostIP = '10.0.2.2'; // Points to localhost when inside Android emulator
    final response = await http.get(Uri.parse('http://$localhostIP:8080/workouts'));

    if (response.statusCode == 200) {
      final List<dynamic> workouts = jsonDecode(response.body);

      return workouts.map((dyn) => Workout.fromJson(dyn)).toList();
    } else {
      throw Exception("Poopy stinky");
    }
  }