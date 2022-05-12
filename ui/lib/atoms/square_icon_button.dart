import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/themed_icon.dart';

class SquareIconButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  const SquareIconButton(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      child: Icon(icon),
      onPressed: onPressed,
      style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4))),
    );
  }
}
