import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/models/meal.dart';
import 'package:ui/molecules/ingredient_input.dart';
import 'package:ui/molecules/ingredient_list.dart';

class IngredientSelector extends StatefulWidget {
  final Function(Ingredient) onSelected;

  const IngredientSelector({Key? key, required this.onSelected})
      : super(key: key);

  @override
  IngredientSelectorState createState() => IngredientSelectorState();
}

class IngredientSelectorState extends State<IngredientSelector> {
  bool selectExistingIngredient = true;

  @override
  Widget build(BuildContext context) {
    if (selectExistingIngredient) {
      return Column(
        children: [
          Expanded(
            child: IngredientList(displayIngredient: (ingredient) {
              return Row(children: [
                Text(ingredient.name),
                NeumorphicButton(
                  child: Text("Select"),
                  onPressed: () {
                    widget.onSelected(ingredient);
                  },
                )
              ]);
            }),
          ),
          NeumorphicButton(
            child: Text("Create New Ingredient"),
            onPressed: () {
              setState(() {
                selectExistingIngredient = false;
              });
            },
          )
        ],
      );
    }

    return IngredientInput(onCreated: widget.onSelected);
  }
}
