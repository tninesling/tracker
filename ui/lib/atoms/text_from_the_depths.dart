import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class TextFromTheDepths extends StatelessWidget {
  final String text;

  const TextFromTheDepths({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      builder: (context, depth, child) {
        return NeumorphicText(
          text,
          textStyle: NeumorphicTextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          style: NeumorphicStyle(depth: depth)
        );
      }
    );
  }
}