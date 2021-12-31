import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class Point {
  final num x;
  final num y;

  Point({required this.x, required this.y});
}

class ScatterPlot extends StatelessWidget {
  final List<Point> points;
  final List<Point> regressionLineEndpoints;

  ScatterPlot({Key? key, required this.points, this.regressionLineEndpoints = const []});

  @override
  Widget build(BuildContext context) {
    return ScatterPlotChart(
        [_createPointSeries(), _createRegressionLineSeries()],
        animate: false,
        defaultRenderer: PointRendererConfig(),
        customSeriesRenderers: [
          LineRendererConfig(customRendererId: 'regressionLine')
        ],
      );
  }

  Series<Point, num> _createPointSeries() {
    return Series(
      id: 'pointSeries',
      data: points,
      domainFn: (p, _) => p.x,
      measureFn: (p, _) => p.y,
      seriesColor: MaterialPalette.black,
    );
  }

  Series<Point, num> _createRegressionLineSeries() {
    return Series(
      id: 'regressionSeries',
      // TODO calculate regression points
      data: regressionLineEndpoints,
      domainFn: (p, _) => p.x,
      measureFn: (p, _) => p.y,
      seriesColor: MaterialPalette.black,
    )..setAttribute(rendererIdKey, 'regressionLine');
  }
}