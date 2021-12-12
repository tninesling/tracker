import 'package:json_annotation/json_annotation.dart';
part 'dtos.g.dart';

@JsonSerializable()
class CreateWorkoutDto {
  final DateTime date;
  final List<CreateExerciseDto> exercises;

  CreateWorkoutDto(this.date, this.exercises);

  factory CreateWorkoutDto.fromJson(Map<String, dynamic> json) => _$CreateWorkoutDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateWorkoutDtoToJson(this);
}

@JsonSerializable()
class CreateExerciseDto {
  final String name;
  final int reps;
  final int sets;
  final double weightKg;

  CreateExerciseDto(this.name, this.reps, this.sets, this.weightKg);

  factory CreateExerciseDto.fromJson(Map<String, dynamic> json) => _$CreateExerciseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateExerciseDtoToJson(this);
}