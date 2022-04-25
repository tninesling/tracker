import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/themed_icon.dart';
import 'package:ui/screens/add_exercise.dart';
import 'package:ui/screens/add_meal.dart';
import 'package:ui/screens/exercise.dart';
import 'package:ui/screens/feature_request.dart';
import 'package:ui/screens/diet.dart';
import 'package:ui/screens/settings.dart';
import 'package:ui/screens/trends.dart';

enum Screens {
  add,
  diet,
  exercise,
  settings,
  trends,
}

class BottomNav extends StatelessWidget {
  final Screens currentScreen;

  const BottomNav({Key? key, required this.currentScreen}) : super(key: key);

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
                child: const ThemedIcon(Icons.trending_up_sharp),
                value: Screens.trends,
                groupValue: currentScreen,
                onChanged: (str) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => const TrendsScreen()));
                },
              ),
              NeumorphicRadio(
                child: const ThemedIcon(Icons.ramen_dining_sharp),
                value: Screens.diet,
                groupValue: currentScreen,
                onChanged: (str) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => const DietScreen()));
                },
              ),
              NeumorphicRadio(
                child: const ThemedIcon(Icons.fitness_center_sharp),
                value: Screens.exercise,
                groupValue: currentScreen,
                onChanged: (str) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => const ExerciseScreen()));
                },
              ),
              NeumorphicRadio(
                child: const ThemedIcon(Icons.plus_one_sharp),
                value: Screens.add,
                groupValue: currentScreen,
                onChanged: (str) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    switch (currentScreen) {
                      case Screens.diet:
                        return const AddMealScreen();
                      case Screens.exercise:
                        return const AddExerciseScreen();
                      default:
                        return const FeatureRequest();
                    }
                  }));
                },
              ),
              NeumorphicRadio(
                child: const ThemedIcon(Icons.settings),
                value: Screens.settings,
                groupValue: currentScreen,
                onChanged: (str) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => const SettingsScreen()));
                },
              ),
            ],
          ),
        )));
  }
}
