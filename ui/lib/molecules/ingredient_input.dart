import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import 'package:ui/atoms/double_input.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/storage.dart';

class IngredientInput extends StatefulWidget {
  final Function(Ingredient) onCreated;

  const IngredientInput({Key? key, required this.onCreated}) : super(key: key);

  @override
  IngredientInputState createState() => IngredientInputState();
}

class IngredientInputState extends State<IngredientInput> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late double amountGrams;
  late double calories;
  late double carbGrams;
  late double fatGrams;
  late double proteinGrams;
  late double sugarGrams;
  late double sodiumMilligrams;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: ListView(children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid name';
              }
            },
          ),
          DoubleInput(
              label: "Amount (g)",
              onChanged: (newAmountGrams) {
                setState(() {
                  amountGrams = newAmountGrams;
                });
              }),
          DoubleInput(
              label: "Calories",
              onChanged: (newCalories) {
                setState(() {
                  calories = newCalories;
                });
              }),
          DoubleInput(
              label: "Carbs (g)",
              onChanged: (newCarbGrams) {
                setState(() {
                  carbGrams = newCarbGrams;
                });
              }),
          DoubleInput(
              label: "Fat (g)",
              onChanged: (newFatGrams) {
                setState(() {
                  fatGrams = newFatGrams;
                });
              }),
          DoubleInput(
              label: "Protein (g)",
              onChanged: (newProteinGrams) {
                setState(() {
                  proteinGrams = newProteinGrams;
                });
              }),
          DoubleInput(
              label: "Sugar (g)",
              onChanged: (newSugarGrams) {
                setState(() {
                  sugarGrams = newSugarGrams;
                });
              }),
          DoubleInput(
            label: "Sodium (mg)",
            onChanged: (newSodiumMilligrams) {
              setState(() {
                sodiumMilligrams = newSodiumMilligrams;
              });
            },
          ),
          NeumorphicButton(
            child: const Text("Submit"),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context
                    .read<Storage>()
                    .createIngredient(CreateIngredientRequest(
                      name: name,
                      amountGrams: amountGrams,
                      calories: calories,
                      carbGrams: carbGrams,
                      fatGrams: fatGrams,
                      proteinGrams: proteinGrams,
                      sugarGrams: sugarGrams,
                      sodiumMilligrams: sodiumMilligrams,
                    ))
                    .then(widget.onCreated);
              }
            },
          )
        ]));
  }
}
