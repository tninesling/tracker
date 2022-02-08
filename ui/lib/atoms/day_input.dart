import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class DayInput extends StatelessWidget {
  final Function(DateTime) onChanged;

  const DayInput({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          return NeumorphicButton(
            child: Text(dayOffsetText(index)),
            onPressed: () {
              onChanged(DateTime.now().subtract(Duration(days: index)));
            },
          );
        });
  }

  String dayOffsetText(int offset) {
    if (offset == 0) {
      return "Today";
    }

    if (offset == 1) {
      return "Yesterday";
    }

    return "$offset days ago";
  }
}
