import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../basic.dart';
import '../bottom_nav.dart';

class AddDietScreen extends StatelessWidget {
  const AddDietScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: TextFromTheDepths(text: "How was your meal?")),
      bottomNavigationBar: BottomNav(groupValue: "Add"),
    );
  }
}