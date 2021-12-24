import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/neu/add/add_diet.dart';
import 'package:ui/neu/add/add_exercise.dart';
import 'package:ui/neu/diet.dart';
import 'package:ui/neu/exercise.dart';
import 'package:ui/neu/add/feature_request.dart';
import 'package:ui/neu/settings.dart';
import 'package:ui/neu/sleep.dart';

import 'add/add_sleep.dart';
import 'atoms/themed_icon.dart';

class BottomNav extends StatelessWidget {
  final String groupValue;

  const BottomNav({Key? key, required this.groupValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "bottomNav",
      child: NeumorphicBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicRadio(
                child: const ThemedIcon(Icons.fitness_center_sharp),
                value: "Exercise",
                groupValue: groupValue,
                onChanged: (str) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => const ExerciseScreen()
                    )
                  );
                },
              ),
              NeumorphicRadio(
                child: const ThemedIcon(Icons.ramen_dining_sharp),
                value: "Diet",
                groupValue: groupValue,
                onChanged: (str) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => const DietScreen()
                    )
                  );
                },
              ),
              NeumorphicRadio(
                child: const ThemedIcon(Icons.bedtime_sharp),
                value: "Sleep",
                groupValue: groupValue,
                onChanged: (str) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => const SleepScreen()
                    )
                  );
                },
              ),
              NeumorphicRadio(
                child: const ThemedIcon(Icons.plus_one_sharp),
                value: "Add",
                groupValue: groupValue,
                onChanged: (str) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
                        switch (groupValue) {
                          case "Diet":
                            return const AddDietScreen();
                          case "Exercise":
                            return const AddExerciseScreen();
                          case "Sleep":
                            return const AddSleepScreen();
                          default:
                            return const FeatureRequest();
                        }
                      }
                    )
                  );
                },
              ),
              NeumorphicRadio(
                child: const ThemedIcon(Icons.settings),
                value: "Settings",
                groupValue: groupValue,
                onChanged: (str) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => const SettingsScreen()
                    )
                  );
                },
              ),
            ],
          ),
        )
      )
  );
}}