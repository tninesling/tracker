import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/models/workout.dart';

class ExerciseInput extends StatefulWidget {
  final Function(CreateExerciseRequest) onSubmit;
  final List<String> supportedUnits = ["kg", "s"];

  ExerciseInput({required this.onSubmit});

  @override
  State<ExerciseInput> createState() => _ExerciseInputState();
}

class _ExerciseInputState extends State<ExerciseInput> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String unit;
  late int amount;

  @override
  void initState() {
    super.initState();
    unit = widget.supportedUnits.elementAt(0);
  }

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
          NeumorphicToggle(
            thumb: Neumorphic(
              style: NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.roundRect(
                      const BorderRadius.all(Radius.circular(12)))),
            ),
            children: widget.supportedUnits
                .map((u) => ToggleElement(
                    background: Center(child: Text(u)),
                    foreground: Center(
                      child: Text(u),
                    )))
                .toList(),
            selectedIndex: widget.supportedUnits.indexOf(unit),
            onChanged: (index) {
              setState(() {
                unit = widget.supportedUnits.elementAt(index);
              });
            },
          ),
          NeumorphicButton(
            child: const Text("Submit"),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(CreateExerciseRequest(name: name, unit: unit));
              }
            },
          )
        ]));
  }
}
