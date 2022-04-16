import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/day_display.dart';

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
              child: Center(child: DayDisplay(date: date)),
              onPressed: () {
                onChanged(date);
              },
            ),
          );
        });
  }
}
