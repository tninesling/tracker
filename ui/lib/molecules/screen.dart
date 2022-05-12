import 'package:flutter/material.dart';
import 'package:ui/molecules/bottom_nav.dart';

class Screen extends StatelessWidget {
  final Widget body;
  final Screens screen;

  const Screen({Key? key, required this.body, required this.screen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
        child: body,
      ),
      bottomNavigationBar: BottomNav(currentScreen: screen),
    );
  }
}
