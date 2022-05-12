import 'package:flutter/widgets.dart';

class Header extends StatelessWidget {
  final String text;

  const Header(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
}
