import 'package:openapi/api.dart' as openapi;

class Trend {
  final String name;
  final List<Point> points;
  final Line line;

  Trend({required this.name, required this.points, required this.line});

  factory Trend.fromOpenapi(openapi.Trend t) => Trend(
        name: t.name,
        points: t.points.map(Point.fromOpenapi).toList(),
        line: Line.fromOpenapi(t.line),
      );
}

class Point {
  final double x;
  final double y;
  final String label;

  Point({required this.x, required this.y, required this.label});

  factory Point.fromOpenapi(openapi.Point p) => Point(
        x: p.x,
        y: p.y,
        label: p.label,
      );
}

class Line {
  final double slope;
  final double intercept;

  Line({required this.slope, required this.intercept});

  factory Line.fromOpenapi(openapi.Line l) => Line(
        slope: l.slope,
        intercept: l.intercept,
      );

  Point pointAt(double x) => Point(
        x: x,
        y: x * slope + intercept,
        label: '',
      );
}
