import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class TimeInput extends StatelessWidget {
  final Function(Duration) onChanged;

  const TimeInput({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 48,
      itemBuilder: (context, index) {
        return NeumorphicButton(
          child: Text(halfHourTimeString(index)),
          onPressed: () {
            onChanged(Duration(minutes: index * 30));
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
