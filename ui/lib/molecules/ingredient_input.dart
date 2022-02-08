import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/double_input.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/client.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            onChanged: (value) {
              name = value;
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
                amountGrams = newAmountGrams;
              }),
          DoubleInput(
              label: "Calories",
              onChanged: (newCalories) {
                calories = newCalories;
              }),
          DoubleInput(
              label: "Carbs (g)",
              onChanged: (newCarbGrams) {
                carbGrams = newCarbGrams;
              }),
          DoubleInput(
              label: "Fat (g)",
              onChanged: (newFatGrams) {
                fatGrams = newFatGrams;
              }),
          DoubleInput(
              label: "Protein (g)",
              onChanged: (newProteinGrams) {
                proteinGrams = newProteinGrams;
              }),
          NeumorphicButton(
            child: const Text("Submit"),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                apiClient
                    .createIngredient(CreateIngredientRequest(
                      name: name,
                      amountGrams: amountGrams,
                      calories: calories,
                      carbGrams: carbGrams,
                      fatGrams: fatGrams,
                      proteinGrams: proteinGrams,
                    ))
                    .then(widget.onCreated);
              }
            },
          )
        ]));
  }
}
