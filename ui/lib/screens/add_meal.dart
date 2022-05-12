import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/molecules/meal_input.dart';
import 'package:ui/molecules/screen.dart';

class AddMealScreen extends StatelessWidget {
  const AddMealScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Screen(
      body: MealInput(onCreated: (_) {
        Navigator.of(context).pop();
      }),
      screen: Screens.add);
}
