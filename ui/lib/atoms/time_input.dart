import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/clock.dart';
import 'package:ui/atoms/time_display.dart';
import 'package:ui/utils/date_builder.dart';

class TimeInput extends StatelessWidget {
  final Function(Duration) onChanged;

  const TimeInput({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const NeumorphicClock();
    /*
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 48,
      itemBuilder: (context, index) {
        var durationSinceMidnight = Duration(minutes: index * 30);

        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: NeumorphicButton(
            child: Center(
              child: TimeDisplay(
                  date: DateBuilder()
                      .today()
                      .dayStart()
                      .build()
                      .add(durationSinceMidnight)),
            ),
            onPressed: () {
              onChanged(durationSinceMidnight);
            },
          ),
        );
      },
    );
    */
  }
}
