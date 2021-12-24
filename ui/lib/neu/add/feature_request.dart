import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../basic.dart';
import '../bottom_nav.dart';

class FeatureRequest extends StatelessWidget {
  const FeatureRequest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: TextFromTheDepths(text: "Looking for something?")),
      bottomNavigationBar: BottomNav(groupValue: "Add"),
    );
  }
}