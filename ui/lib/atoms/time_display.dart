import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  final DateTime date;

  const TimeDisplay({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(date.toLocal().toIso8601String().substring(11, 16));
  }
}
