import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/molecules/meal_input.dart';

class AddDietScreen extends StatelessWidget {
  const AddDietScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: MealInput(onCreated: (_) {
        Navigator.of(context).pop();
      })),
      bottomNavigationBar: const BottomNav(groupValue: "Add"),
    );
  }
}
