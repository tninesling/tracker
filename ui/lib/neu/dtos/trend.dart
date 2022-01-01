import 'package:json_annotation/json_annotation.dart';
part 'trend.g.dart';

@JsonSerializable()
class LineDto {
  final double slope;
  final double intercept;

  LineDto(this.slope, this.intercept);

  factory LineDto.fromJson(Map<String, dynamic> json) => _$LineDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LineDtoToJson(this);
}

@JsonSerializable()
class PointDto {
  final double x;
  final double y;
  final String label;

  PointDto(this.x, this.y, this.label);

  factory PointDto.fromJson(Map<String, dynamic> json) => _$PointDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PointDtoToJson(this);
}

@JsonSerializable()
class TrendDto {
  final List<PointDto> points;
  final LineDto line;

  TrendDto(this.points, this.line);

  factory TrendDto.fromJson(Map<String, dynamic> json) => _$TrendDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TrendDtoToJson(this);
}