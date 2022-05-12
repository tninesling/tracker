import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class IntegerInput extends StatelessWidget {
  final String label;
  final Function(int) onChanged;

  const IntegerInput({Key? key, required this.label, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a valid number';
          }
          return null;
        },
        onChanged: (value) {
          var asInt = int.tryParse(value);

          if (asInt != null) {
            onChanged(asInt);
          }
        },
      ),
      style: const NeumorphicStyle(depth: -2),
    );
  }
}
