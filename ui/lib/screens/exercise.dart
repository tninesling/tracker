import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/molecules/bottom_nav.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
          child: Center(child: Text("TODO"))),
      bottomNavigationBar: BottomNav(currentScreen: Screens.exercise),
    );
  }
}
