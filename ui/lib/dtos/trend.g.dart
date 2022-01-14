// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineDto _$LineDtoFromJson(Map<String, dynamic> json) => LineDto(
      (json['slope'] as num).toDouble(),
      (json['intercept'] as num).toDouble(),
    );

Map<String, dynamic> _$LineDtoToJson(LineDto instance) => <String, dynamic>{
      'slope': instance.slope,
      'intercept': instance.intercept,
    };

PointDto _$PointDtoFromJson(Map<String, dynamic> json) => PointDto(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      json['label'] as String,
    );

Map<String, dynamic> _$PointDtoToJson(PointDto instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'label': instance.label,
    };

TrendDto _$TrendDtoFromJson(Map<String, dynamic> json) => TrendDto(
      json['name'] as String,
      (json['points'] as List<dynamic>)
          .map((e) => PointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      LineDto.fromJson(json['line'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrendDtoToJson(TrendDto instance) => <String, dynamic>{
      'name': instance.name,
      'points': instance.points,
      'line': instance.line,
    };
