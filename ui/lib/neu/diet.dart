import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/neu/bottom_nav.dart';

import 'basic.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 64),
        child: Column(
          children: [
            const TextFromTheDepths(text: "Eat something?"),
            _buildIndicators(context)
          ]
        ),
      ),
      bottomNavigationBar: const BottomNav(groupValue: "Diet"),
    );
  }

   Widget _buildIndicators(BuildContext context) {
    final values = [0.8, 0.9, 0.5, 0.7];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: values.map((v) =>
          Column(
            children: [
              NeumorphicIndicator(
                percent: v,
                height: 100,
                width: 20,
                style: IndicatorStyle(
                  variant: Colors.indigo.shade300,
                  accent: Colors.indigo.shade300,
                )
              ),
              Text("C"),
            ]
          )
          
        ).toList()
      ),
    );
  }
}

class Macros extends StatelessWidget {
  const Macros({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Macros");
  }
}