import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/molecules/bottom_nav.dart';

class AddExerciseScreen extends StatelessWidget {
  const AddExerciseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 8),
        child: Center(child: Text("TODO: AddExerciseScreen")),
      ),
      bottomNavigationBar: BottomNav(currentScreen: Screens.add),
    );
  }
}
