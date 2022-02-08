import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/day_input.dart';
import 'package:ui/atoms/time_input.dart';

class DateTimeInput extends StatefulWidget {
  final Function(DateTime) onChanged;

  const DateTimeInput({Key? key, required this.onChanged}) : super(key: key);

  @override
  DateTimeInputState createState() => DateTimeInputState();
}

class DateTimeInputState extends State<DateTimeInput> {
  DateTime? day;

  @override
  Widget build(BuildContext context) {
    if (day == null) {
      return DayInput(
        onChanged: (pickedDay) {
          setState(() {
            day = pickedDay;
          });
        },
      );
    }

    return TimeInput(
      onChanged: (durationSinceMidnight) {
        widget.onChanged(DateTime(
          day!.year,
          day!.month,
          day!.day,
        ).add(durationSinceMidnight));
      },
    );
  }
}
