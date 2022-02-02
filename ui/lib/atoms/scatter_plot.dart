import 'dart:math';

import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:ui/models/trend.dart';

class ScatterPlot extends StatelessWidget {
  final Iterable<Trend> trends;

  const ScatterPlot({Key? key, required this.trends}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScatterPlotChart(
      trends
          .expand(
              (t) => [_createPointSeries(t), _createRegressionLineSeries(t)])
          .toList(),
      animate: false,
      defaultRenderer: PointRendererConfig(),
      customSeriesRenderers: [
        LineRendererConfig(customRendererId: 'regressionLine')
      ],
    );
  }

  Series<Point, num> _createPointSeries(Trend trend) {
    return Series(
      id: 'pointSeries-' + trend.name,
      data: trend.points,
      domainFn: (p, _) => p.x,
      measureFn: (p, _) => p.y,
      seriesColor: MaterialPalette.black,
    );
  }

  Series<Point, num> _createRegressionLineSeries(Trend trend) {
    double minX = trend.points.fold(double.infinity, (acc, p) => min(acc, p.x));
    double maxX =
        trend.points.fold(double.negativeInfinity, (acc, p) => max(acc, p.x));
    var regressionLineEndpoints = [
      trend.line.pointAt(minX),
      trend.line.pointAt(maxX),
    ];

    return Series(
      id: 'regressionSeries-' + trend.name,
      data: regressionLineEndpoints,
      domainFn: (p, _) => p.x,
      measureFn: (p, _) => p.y,
      seriesColor: MaterialPalette.black,
    )..setAttribute(rendererIdKey, 'regressionLine');
  }
}
