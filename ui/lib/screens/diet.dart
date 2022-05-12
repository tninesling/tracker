import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/atoms/day_display.dart';
import 'package:ui/atoms/time_display.dart';
import 'package:ui/molecules/screen.dart';
import 'package:ui/storage.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/molecules/bottom_nav.dart';
import 'package:ui/state.dart';
import 'package:ui/utils/date_builder.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({Key? key}) : super(key: key);

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  late DateTime date;
  late Future<Iterable<Meal>> futureMeals;

  @override
  void initState() {
    super.initState();
    date = DateBuilder().today().dayStart().build();
    futureMeals = context.read<Storage>().getAllMeals(
        DateFilter(after: date, before: date.add(const Duration(days: 1))));
  }

  @override
  Widget build(BuildContext context) => Screen(
        body: Consumer<AppState>(builder: (context, state, child) {
          return ListView(
            children: [
              Header(
                child: DayDisplay(date: date),
                onArrowLeft: () {
                  setState(() {
                    date = date.subtract(const Duration(days: 1));
                    futureMeals = context.read<Storage>().getAllMeals(
                        DateFilter(
                            after: date,
                            before: date.add(const Duration(days: 1))));
                  });
                },
                onArrowRight: () {
                  setState(() {
                    date = date.add(const Duration(days: 1));
                    futureMeals = context.read<Storage>().getAllMeals(
                        DateFilter(
                            after: date,
                            before: date.add(const Duration(days: 1))));
                  });
                },
              ),
              const Text("Summary",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              FutureBuilder<Iterable<Meal>>(
                future: futureMeals,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error");
                  }

                  if (!snapshot.hasData) {
                    return Text("Loading");
                  }

                  return Indicators(meals: snapshot.data!);
                },
              ),
              const Divider(),
              const Text("Meals",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 1000,
                child: FutureBuilder<Iterable<Meal>>(
                  future: futureMeals,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error");
                    }

                    if (!snapshot.hasData) {
                      return Text("Loading");
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) =>
                          MealRow(meal: snapshot.data!.elementAt(index)),
                    );
                  },
                ),
              )
            ],
          );
        }),
        screen: Screens.diet,
      );
}

class Header extends StatelessWidget {
  final Widget child;
  final Function onArrowLeft;
  final Function onArrowRight;

  const Header(
      {required this.child,
      required this.onArrowLeft,
      required this.onArrowRight});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: Consumer<Storage>(
            builder: (context, storage, child) => NeumorphicButton(
                child: const Center(child: Icon(Icons.arrow_left)),
                onPressed: () {
                  onArrowLeft();
                }),
          ),
          height: 48,
          width: 48,
        ),
        Expanded(
            child: Center(
                child: child)), // Center(child: DayDisplay(date: date))),
        SizedBox(
          child: Consumer<Storage>(
            builder: (context, storage, child) => NeumorphicButton(
                child: const Center(child: Icon(Icons.arrow_right)),
                onPressed: () {
                  onArrowRight();
                }),
          ),
          height: 48,
          width: 48,
        ),
      ],
    );
  }
}

class Indicators extends StatelessWidget {
  Iterable<Meal> meals;

  Indicators({Key? key, required this.meals}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, child) {
      Meal allMeals = meals.fold(Meal.empty(), (all, m) {
        return all.add(m);
      });
      var values = [
        Target(
            name: "Calories",
            value: allMeals.calories,
            targetValue: state.targetCalories()),
        Target(
            name: "Carbs (g)",
            value: allMeals.carbGrams,
            targetValue: state.targetCarbGrams()),
        Target(
            name: "Fat (g)",
            value: allMeals.fatGrams,
            targetValue: state.targetFatGrams()),
        Target(
            name: "Protein (g)",
            value: allMeals.proteinGrams,
            targetValue: state.targetProteinGrams()),
        Target(
          name: "Sugar (g)",
          value: allMeals.sugarGrams,
          targetValue: state.targetSugarGrams(),
        ),
        Target(
          name: "Sodium (mg)",
          value: allMeals.sodiumMilligrams,
          targetValue: state.targetSodiumMilligrams(),
        )
      ];

      return Column(
        children: values,
      );
    });
  }
}

class Target extends StatelessWidget {
  final String name;
  final double value;
  final double targetValue;

  const Target(
      {required this.name, required this.value, required this.targetValue});

  String getName() => name;

  double getPercentCompleted() => value / targetValue;

  double getPercentError() => (1 - getPercentCompleted()).abs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(child: Text(getName()), width: 90),
        SizedBox(child: Text("${value.round()}"), width: 40),
        Expanded(
            child: NeumorphicProgress(
          percent: getPercentCompleted(),
          style: ProgressStyle(
              accent: _selectIndicatorColor(getPercentError()), depth: -1),
        )),
        SizedBox(
            child: Text(
              "${targetValue.round()}",
              textAlign: TextAlign.right,
            ),
            width: 40)
      ],
    );
  }

  // TODO soften these colors with some color harmony
  Color _selectIndicatorColor(double percentError) {
    return Color.lerp(
            Colors.green.shade200, Colors.red.shade200, percentError) ??
        Colors.black;
  }
}

class MealRow extends StatelessWidget {
  final Meal meal;

  const MealRow({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          TimeDisplay(date: meal.date),
          NeumorphicButton(
            child: const Text("Delete"),
            onPressed: () {
              context.read<Storage>().deleteMeal(meal.id).then((_) {
                context.read<AppState>().removeMeal(meal);
              });
            },
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
