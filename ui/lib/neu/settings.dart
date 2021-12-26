import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../state.dart';
import 'bottom_nav.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NeumorphicBackground(
        child:
          Container(
            padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 8),
            child: Column(children: [
              _buildThemeSwitcher(context),
              _buildTargetCaloriesSetter(),
            ]
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(groupValue: "Settings"),
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    return NeumorphicSwitch(
      value: NeumorphicTheme.isUsingDark(context),
      style: NeumorphicSwitchStyle(
        activeTrackColor: NeumorphicTheme.baseColor(context),
      ),
      onChanged: (isUsingDark) {
        NeumorphicTheme.of(context)?.themeMode =
            isUsingDark ? ThemeMode.dark : ThemeMode.light;
      },
    );
  }

  Widget _buildTargetCaloriesSetter() {
    return Consumer<DietState>(builder: (context, state, child) {
      // TODO style with neumorphism
      return TextFormField(
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
        onChanged: (text) {
          state.setTargetCalories(double.parse(text));
        },
      );
    });
  }
}
