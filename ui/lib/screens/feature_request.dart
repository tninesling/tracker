import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/text_from_the_depths.dart';
import 'package:ui/molecules/bottom_nav.dart';

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