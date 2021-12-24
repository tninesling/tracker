import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'bottom_nav.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
        child: Column(
          children: [
            NeumorphicSwitch(
              value: NeumorphicTheme.isUsingDark(context),
              style: NeumorphicSwitchStyle(
                activeTrackColor: NeumorphicTheme.baseColor(context),
              ),
              onChanged: (isUsingDark) {
                NeumorphicTheme.of(context)?.themeMode = isUsingDark ? ThemeMode.dark : ThemeMode.light;
              },
            )
          ]
        )
      ),
      bottomNavigationBar: const BottomNav(groupValue: "Settings"),
    );
  }
}