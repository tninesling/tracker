import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/themed_icon.dart';
import 'package:ui/screens/add/add_diet.dart';
import 'package:ui/screens/add/feature_request.dart';
import 'package:ui/screens/diet.dart';
import 'package:ui/screens/settings.dart';
import 'package:ui/screens/trends.dart';

class BottomNav extends StatelessWidget {
  final String groupValue;

  const BottomNav({Key? key, required this.groupValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "bottomNav",
        child: NeumorphicBackground(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicRadio(
                child: const ThemedIcon(Icons.trending_up_sharp),
                value: "Trends",
                groupValue: groupValue,
                onChanged: (str) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => TrendsScreen()));
                },
              ),
              NeumorphicRadio(
                child: const ThemedIcon(Icons.ramen_dining_sharp),
                value: "Diet",
                groupValue: groupValue,
                onChanged: (str) {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (ctx) => DietScreen()));
                },
              ),
              NeumorphicRadio(
                child: const ThemedIcon(Icons.plus_one_sharp),
                value: "Add",
                groupValue: groupValue,
                onChanged: (str) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    switch (groupValue) {
                      case "Diet":
                        return const AddDietScreen();
                      default:
                        return const FeatureRequest();
                    }
                  }));
                },
              ),
              NeumorphicRadio(
                child: const ThemedIcon(Icons.settings),
                value: "Settings",
                groupValue: groupValue,
                onChanged: (str) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => const SettingsScreen()));
                },
              ),
            ],
          ),
        )));
  }
}
