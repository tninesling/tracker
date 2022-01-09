import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../atoms/text_from_the_depths.dart';
import '../molecules/bottom_nav.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: const Center(child: TextFromTheDepths(text: "Workout time!")),
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