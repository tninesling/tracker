import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:ui/atoms/double_input.dart';

class AmountForm extends StatefulWidget {
  final String unit;
  final Function(double) onSubmit;

  const AmountForm({Key? key, required this.unit, required this.onSubmit})
      : super(key: key);

  @override
  AmountFormState createState() => AmountFormState();
}

class AmountFormState extends State<AmountForm> {
  double? amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DoubleInput(
            label: "Amount (${widget.unit})",
            onChanged: (newAmount) {
              setState(() {
                amount = newAmount;
              });
            }),
        NeumorphicButton(
          child: const Text("Submit"),
          onPressed: () {
            if (amount != null) {
              widget.onSubmit(amount!);
            }
          },
        )
      ],
    );
  }
}
