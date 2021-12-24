import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'basic.dart';
import 'bottom_nav.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: TextFromTheDepths(text: "Sleep well?")),
      bottomNavigationBar: BottomNav(groupValue: "Sleep"),
    );
  }
}