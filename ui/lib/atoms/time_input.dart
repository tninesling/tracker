import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/time_display.dart';
import 'package:ui/utils/date_builder.dart';

class TimeInput extends StatelessWidget {
  final Function(Duration) onChanged;

  const TimeInput({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 48,
      itemBuilder: (context, index) {
        var durationSinceMidnight = Duration(minutes: index * 30);

        return NeumorphicButton(
          child: TimeDisplay(
              date: DateBuilder()
                  .today()
                  .dayStart()
                  .build()
                  .add(durationSinceMidnight)),
          onPressed: () {
            onChanged(durationSinceMidnight);
          },
        );
      },
    );
  }

  String halfHourTimeString(int multiple) {
    var hour = multiple / 2;
    var minutes = multiple % 2 * 30;

    return "$hour:$minutes";
  }
}
