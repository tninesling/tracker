import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/molecules/workout_input.dart';
import 'package:ui/storage.dart';

class AddWorkoutScreen extends StatelessWidget {
  const AddWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
        child: Center(
            child: Consumer<Storage>(
          builder: (context, storage, child) =>
              WorkoutInput(onSubmit: (unsavedWorkout) {
            storage
                .createWorkout(unsavedWorkout)
                .then((_) => Navigator.of(context).pop())
                .onError((error, stackTrace) =>
                    Fluttertoast.showToast(msg: error.toString()));
          }),
        )),
      ),
      bottomNavigationBar: const BottomNav(currentScreen: Screens.add),
    );
  }
}
