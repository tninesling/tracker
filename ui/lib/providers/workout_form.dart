import 'package:flutter/foundation.dart';
import 'package:ui/dtos.dart';

class WorkoutFormState with ChangeNotifier {
  DateTime _date = DateTime.now();
  List<CreateExerciseDto> _exercises = [];

  DateTime get date => _date;
  List<CreateExerciseDto> get exercises => _exercises;

  void setDate(DateTime newDate) {
    _date = newDate;
    notifyListeners();
  }

  void addExercise(CreateExerciseDto exercise) {
    _exercises.add(exercise);
    notifyListeners();
  }

  void reset() {
    _date = DateTime.now();
    _exercises = [];
    notifyListeners();
  }
}