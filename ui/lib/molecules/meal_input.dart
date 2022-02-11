import 'dart:collection';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/double_input.dart';
import 'package:ui/client.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/molecules/amount_form.dart';
import 'package:ui/molecules/datetime_input.dart';
import 'package:ui/molecules/ingredient_selector.dart';

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

  MealInputState() : ingredientAmounts = HashMap();

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
        ingredientAmounts.update(ingredient!, (value) => amount!);
      });
    }

    return Column(children: [
      NeumorphicButton(
        child: const Text("Add Ingredient"),
        onPressed: () {
          setState(() {
            ingredient = null;
            amount = null;
          });
        },
      ),
      NeumorphicButton(
          child: const Text("Submit"),
          onPressed: () {
            apiClient
                .createMeal(CreateMealRequest(
                  date: date!,
                  ingredientAmounts: ingredientAmounts,
                ))
                .then(widget.onCreated);
          })
    ]);
  }
}
