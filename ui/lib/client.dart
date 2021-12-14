import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ui/data/daily_workout_summary.dart';
import 'package:ui/dtos.dart';
import 'package:ui/models.dart';

const localhostIP = '10.0.2.2'; // Points to localhost when inside Android emulator
const host = 'http://$localhostIP:8080';

Future<Workout> createNewWorkout(CreateWorkoutDto dto) async {
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  final body = jsonEncode(dto.toJson());
  final response = await http.post(Uri.parse('$host/workouts'), headers: headers, body: body);

  if (response.statusCode == 200) {
    return Workout.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Poopy stinky");
  }
}

Future<List<Workout>> getAllWorkouts() async {
  final response = await http.get(Uri.parse('$host/workouts'));

  if (response.statusCode == 200) {
    final List<dynamic> workouts = jsonDecode(response.body);

    return workouts.map((dyn) => Workout.fromJson(dyn)).toList();
  } else {
    throw Exception("Poopy stinky");
  }
}

Future<List<DailyWorkoutSummary>> getWorkoutSummaries() async {
  final response = await http.get(Uri.parse('$host/summaries/workouts'));

  if (response.statusCode == 200) {
    final List<dynamic> summaries = jsonDecode(response.body);

    return summaries.map((dyn) => DailyWorkoutSummary.fromJson(dyn)).toList();
  } else {
    throw Exception("Poopy stinky");
  }
}