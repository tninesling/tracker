import 'package:json_annotation/json_annotation.dart';
part 'daily_workout_summary.g.dart';

@JsonSerializable()
class DailyWorkoutSummary {
  final DateTime date;
  final double totalWeightKg;

  DailyWorkoutSummary(this.date, this.totalWeightKg);

  factory DailyWorkoutSummary.fromJson(Map<String, dynamic> json) => _$DailyWorkoutSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$DailyWorkoutSummaryToJson(this);
}