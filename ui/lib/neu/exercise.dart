import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'bottom_nav.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  child: Text(
                    "Hey!\nIt's time to work out.",
                    style: NeumorphicTheme.currentTheme(context).textTheme.headline1
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 16),
                ),
                Container(
                  child: Text(
                    "Here's today's plan",
                    style: NeumorphicTheme.currentTheme(context).textTheme.headline2,  
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 16)
                ),
                const ExerciseCard(exercise: "Deadlift: 5x5 @ 210lbs"),
                const ExerciseCard(exercise: "Overhead Press: 5x5 @ 70lbs"),
                const ExerciseCard(exercise: "Leg Curls: 5x10 @ 110lbs"),
                const ExerciseCard(exercise: "Leg Extensions: 5x10 @ 110lbs"),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            RotatedBox(
              child: NeumorphicText(
                "EXERCISE",
                style: const NeumorphicStyle(
                  depth: 1,
                  intensity: 0.6,
                  lightSource: LightSource.bottomLeft
                ),
                textStyle: NeumorphicTextStyle(fontSize: 64, fontWeight: FontWeight.bold),
              ),
              quarterTurns: 1,
            )
          ]
        )
      ),
      bottomNavigationBar: const BottomNav(groupValue: "Exercise")
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String exercise;

  const ExerciseCard({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 2),
      duration: const Duration(seconds: 3),
      builder: (context, depth, child) {
        return Neumorphic(
          child: Text(
            exercise,
            style: NeumorphicTheme.currentTheme(context).textTheme.bodyText1,
          ),
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.symmetric(vertical: 8),
        );
      }
    ); 
  }
}