import 'package:flutter/material.dart';
import 'package:ui/utils/date_builder.dart';

class DayDisplay extends StatelessWidget {
  DateTime date;

  DayDisplay({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(dateText(date));
  }

  String dateText(DateTime date) {
    var thisMorning = DateBuilder().today().dayStart().build();

    if (date.isAfter(thisMorning.add(const Duration(days: 2)))) {
      var asString = date.toIso8601String().substring(5, 10);
      return asString.startsWith('0') ? asString.substring(1) : asString;
    }

    if (date.isAfter(thisMorning.add(const Duration(days: 1)))) {
      return "Tomorrow";
    }

    if (date.isAfter(thisMorning)) {
      return "Today";
    }

    if (date.isAfter(thisMorning.subtract(const Duration(days: 1)))) {
      return "Yesterday";
    }

    var asString = date.toIso8601String().substring(5, 10);
    return asString.startsWith('0') ? asString.substring(1) : asString;
  }
}
