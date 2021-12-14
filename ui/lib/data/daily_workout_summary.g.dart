// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_workout_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyWorkoutSummary _$DailyWorkoutSummaryFromJson(Map<String, dynamic> json) =>
    DailyWorkoutSummary(
      DateTime.parse(json['date'] as String),
      (json['totalWeightKg'] as num).toDouble(),
    );

Map<String, dynamic> _$DailyWorkoutSummaryToJson(
        DailyWorkoutSummary instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'totalWeightKg': instance.totalWeightKg,
    };
