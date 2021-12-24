import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../basic.dart';
import '../bottom_nav.dart';

class AddSleepScreen extends StatelessWidget {
  const AddSleepScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: TextFromTheDepths(text: "How did you sleep?")),
      bottomNavigationBar: BottomNav(groupValue: "Add"),
    );
  }
}