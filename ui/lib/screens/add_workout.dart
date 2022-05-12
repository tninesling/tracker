import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/molecules/screen.dart';
import 'package:ui/molecules/workout_input.dart';
import 'package:ui/state.dart';
import 'package:ui/storage.dart';

class AddWorkoutScreen extends StatelessWidget {
  const AddWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Screen(
      body: Consumer<Storage>(
        builder: (context, storage, child) =>
            WorkoutInput(onSubmit: (unsavedWorkout) {
          storage.createWorkout(unsavedWorkout).then((workout) {
            context.read<AppState>().addWorkouts([workout]);
            Navigator.of(context).pop();
          }).onError((error, stackTrace) {
            Fluttertoast.showToast(msg: error.toString());
          });
        }),
      ),
      screen: Screens.add);
}
