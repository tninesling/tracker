import 'package:ui/dtos/trend.dart';

class Trend {
  final List<Point> points;
  final Line line;

  Trend({required this.points, required this.line});

  factory Trend.fromDto(TrendDto dto) => Trend(
    points: dto.points.map(Point.fromDto).toList(),
    line: Line.fromDto(dto.line),
  );
}

class Point {
  final double x;
  final double y;
  final String label;

  Point({required this.x, required this.y, required this.label});

  factory Point.fromDto(PointDto dto) => Point(x: dto.x, y: dto.y, label: dto.label);
}

class Line {
  final double slope;
  final double intercept;

  Line({required this.slope, required this.intercept});

  factory Line.fromDto(LineDto dto) => Line(slope: dto.slope, intercept: dto.intercept);

  Point pointAt(double x) => Point(
    x: x,
    y: x * slope + intercept,
    label: '',
  );
}