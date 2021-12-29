import 'package:ui/neu/atoms/line_chart.dart';

class TimeseriesPoint {
  final DateTime date;
  final double value;

  TimeseriesPoint({required this.date, required this.value});
}

class NeumorphicTimeseries extends NeumorphicLineChart {
  final List<TimeseriesPoint> timeseriesPoints;

  NeumorphicTimeseries({required this.timeseriesPoints})
      : super(points: timeseriesToPoints(timeseriesPoints));

  static List<Point> timeseriesToPoints(
      List<TimeseriesPoint> timeseriesPoints) {
    if (timeseriesPoints.isEmpty) {
      return [];
    }

    timeseriesPoints.sort((a, b) => a.date.compareTo(b.date));

    return timeseriesPoints
        .map((p) => Point(
            x: p.date.difference(timeseriesPoints[0].date).inDays.toDouble(),
            y: p.value))
        .toList();
  }
}
