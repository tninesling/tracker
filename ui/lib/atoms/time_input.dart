import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/time_display.dart';
import 'package:ui/utils/date_builder.dart';

class TimeInput extends StatefulWidget {
  final Function(Duration) onChanged;

  const TimeInput({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<TimeInput> createState() => _TimeInputState();
}

class _TimeInputState extends State<TimeInput> {
  late double minuteOfDay;

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    minuteOfDay = now.hour * 60 + now.minute.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimeDisplay(
            date: DateBuilder()
                .today()
                .dayStart()
                .build()
                .add(Duration(minutes: minuteOfDay.toInt()))),
        NeumorphicSlider(
            min: 0,
            max: 24 * 60 - 1,
            value: minuteOfDay,
            onChanged: (value) {
              setState(() {
                minuteOfDay = value;
              });
            }),
        NeumorphicButton(
          child: const Text("Submit"),
          onPressed: () {
            widget.onChanged(Duration(minutes: minuteOfDay.toInt()));
          },
        )
      ],
    );
  }
}
