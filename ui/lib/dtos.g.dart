// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWorkoutDto _$CreateWorkoutDtoFromJson(Map<String, dynamic> json) =>
    CreateWorkoutDto(
      DateTime.parse(json['date'] as String),
      (json['exercises'] as List<dynamic>)
          .map((e) => CreateExerciseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CreateWorkoutDtoToJson(CreateWorkoutDto instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'exercises': instance.exercises,
    };

CreateExerciseDto _$CreateExerciseDtoFromJson(Map<String, dynamic> json) =>
    CreateExerciseDto(
      json['name'] as String,
      json['reps'] as int,
      json['sets'] as int,
      (json['weightKg'] as num).toDouble(),
    );

Map<String, dynamic> _$CreateExerciseDtoToJson(CreateExerciseDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'reps': instance.reps,
      'sets': instance.sets,
      'weightKg': instance.weightKg,
    };
