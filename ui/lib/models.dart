import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Workout {
  final String id;
  final DateTime date;

  Workout({
    required this.id,
    required this.date,
  });

  factory Workout.fromJson(Map<String, dynamic> json) => _$WorkoutFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutToJson(this);
}

@JsonSerializable()
class Exercise {
  final String id;

  Exercise({
    required this.id,
  });
}