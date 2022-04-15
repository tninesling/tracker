import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/utils/date_builder.dart';

class DayInput extends StatelessWidget {
  final Function(DateTime) onChanged;

  const DayInput({Key? key, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          var date = DateTime.now().subtract(Duration(days: index));
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: NeumorphicButton(
              child: Center(child: Text(dateText(date))),
              onPressed: () {
                onChanged(date);
              },
            ),
          );
        });
  }

  String dateText(DateTime date) {
    var thisMorning = DateBuilder().today().dayStart().build();

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
