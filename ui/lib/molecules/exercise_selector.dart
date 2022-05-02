import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ui/models/workout.dart';
import 'package:ui/molecules/exercise_input.dart';
import 'package:ui/molecules/exercise_list.dart';
import 'package:ui/storage.dart';

class ExerciseSelector extends StatefulWidget {
  final Function(Exercise) onSelected;

  const ExerciseSelector({Key? key, required this.onSelected})
      : super(key: key);

  @override
  State<ExerciseSelector> createState() => _ExerciseSelectorState();
}

class _ExerciseSelectorState extends State<ExerciseSelector> {
  bool selectExistingExercise = true;

  @override
  Widget build(BuildContext context) {
    if (selectExistingExercise) {
      return Column(
        children: [
          Expanded(
            child: ExerciseList(displayExercise: (exercise) {
              return Row(children: [
                Text(exercise.name),
                NeumorphicButton(
                  child: const Text("Select"),
                  onPressed: () {
                    widget.onSelected(exercise);
                  },
                )
              ]);
            }),
          ),
          NeumorphicButton(
            child: const Text("Create New Exercise"),
            onPressed: () {
              setState(() {
                selectExistingExercise = false;
              });
            },
          )
        ],
      );
    }

    return Consumer<Storage>(
        builder: (context, storage, child) =>
            ExerciseInput(onSubmit: (unsavedExercise) {
              storage
                  .createExercise(unsavedExercise)
                  .then(widget.onSelected)
                  .onError((error, stackTrace) =>
                      Fluttertoast.showToast(msg: error.toString()));
            }));
  }
}
