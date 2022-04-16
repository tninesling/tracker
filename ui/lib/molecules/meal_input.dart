import 'dart:collection';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/client.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/molecules/amount_form.dart';
import 'package:ui/molecules/datetime_input.dart';
import 'package:ui/molecules/ingredient_selector.dart';
import 'package:ui/state.dart';

enum MealInputStage {
  pickDateTime,
  pickIngredient,
  pickIngredientAmount,
}

class MealInput extends StatefulWidget {
  final Function(Meal) onCreated;

  const MealInput({Key? key, required this.onCreated}) : super(key: key);

  @override
  MealInputState createState() => MealInputState();
}

class MealInputState extends State<MealInput> {
  DateTime? date;
  Ingredient? ingredient;
  double? amount;
  Map<Ingredient, double> ingredientAmounts;

  MealInputState()
      : ingredientAmounts = HashMap(
            equals: (i1, i2) => i1.id == i2.id, hashCode: (i) => i.id.hashCode);

  @override
  Widget build(BuildContext context) {
    if (date == null) {
      return DateTimeInput(onChanged: (pickedDate) {
        setState(() {
          date = pickedDate;
        });
      });
    }

    if (ingredient == null) {
      return IngredientSelector(onSelected: (selected) {
        setState(() {
          ingredient = selected;
        });
      });
    }

    if (amount == null) {
      return AmountForm(onSubmit: (newAmountGrams) {
        setState(() {
          amount = newAmountGrams;
        });
        ingredientAmounts.update(ingredient!, (_) => amount!,
            ifAbsent: () => amount!);
      });
    }

    return ListView(children: [
      ...ingredientAmounts.entries.map((entry) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(entry.key.name),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  ingredientAmounts.remove(entry.key);
                });
              },
            ),
          ],
        );
      }),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NeumorphicButton(
                child: const Text("Add Ingredient"),
                onPressed: () {
                  setState(() {
                    ingredient = null;
                    amount = null;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<Storage>(
                builder: (context, storage, child) => NeumorphicButton(
                    child: const Text("Submit"),
                    onPressed: () {
                      storage
                          .createMeal(CreateMealRequest(
                        date: date!,
                        ingredientAmounts: ingredientAmounts.map(
                            (ingredient, amount) =>
                                MapEntry(ingredient.id, amount)),
                      ))
                          .then((meal) {
                        context.read<DietState>().addMeals([meal]);
                        widget.onCreated(meal);
                      });
                    }),
              ),
            ),
          )
        ],
      ),
    ]);
  }
}
