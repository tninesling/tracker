import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class DoubleInput extends StatelessWidget {
  final String label;
  final Function(double) onChanged;

  const DoubleInput({Key? key, required this.label, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null ||
              value.isEmpty ||
              double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
        onChanged: (value) {
          var asDouble = double.tryParse(value);

          if (asDouble != null) {
            onChanged(asDouble);
          }
        },
      ),
      style: const NeumorphicStyle(depth: -2),
    );
  }
}
