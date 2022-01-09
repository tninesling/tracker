import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../atoms/text_from_the_depths.dart';
import '../molecules/bottom_nav.dart';

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