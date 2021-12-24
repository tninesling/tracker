import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ThemedIcon extends StatelessWidget {
  final IconData iconData;

  const ThemedIcon(this.iconData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Icon(
        iconData,
        color: NeumorphicTheme.currentTheme(context).iconTheme.color,
        size: 32,
      ),
    );
  }
}