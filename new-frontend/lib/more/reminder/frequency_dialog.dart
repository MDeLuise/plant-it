import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:wheel_picker/wheel_picker.dart';
import 'package:plant_it/loading_button.dart';

class FrequencyDialog extends StatefulWidget {
  final Environment env;
  final Function(int quantity, FrequencyUnit unit) callback;
  final int? initialQuantity;
  final FrequencyUnit? initialUnit;

  const FrequencyDialog(
      this.env, this.callback, this.initialQuantity, this.initialUnit,
      {super.key});

  @override
  State<FrequencyDialog> createState() => _FrequencyDialogState();
}

class _FrequencyDialogState extends State<FrequencyDialog> {
  late int _selectedQuantity;
  late FrequencyUnit _selectedUnit;
  final List<FrequencyUnit> _units = FrequencyUnit.values;

  @override
  void initState() {
    super.initState();
    _selectedQuantity = widget.initialQuantity ?? 2;
    _selectedUnit = widget.initialUnit ?? FrequencyUnit.days;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .25,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Quantity Picker
            SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: WheelPicker(
                itemCount: 365,
                builder: (context, index) => Text("${index + 1}"),
                selectedIndexColor: Theme.of(context).colorScheme.primary,
                looping: true,
                initialIndex: _selectedQuantity - 1,
                style: const WheelPickerStyle(
                  squeeze: 1.25,
                  diameterRatio: .8,
                  surroundingOpacity: .25,
                  magnification: 1.2,
                ),
                onIndexChanged: (index, interactionType) {
                  setState(() {
                    _selectedQuantity = index + 1;
                  });
                },
              ),
            ),

            // Unit Picker
            SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: WheelPicker(
                itemCount: _units.length,
                builder: (context, index) => Text(_units[index].name),
                selectedIndexColor: Theme.of(context).colorScheme.primary,
                looping: false,
                initialIndex: _units.indexOf(_selectedUnit),
                style: const WheelPickerStyle(
                  squeeze: 1.25,
                  diameterRatio: .8,
                  surroundingOpacity: .25,
                  magnification: 1.2,
                ),
                onIndexChanged: (index, interactionType) {
                  setState(() {
                    _selectedUnit = _units[index];
                  });
                },
              ),
            ),

            // Confirm Button
            LoadingButton(
              'Ok',
              () {
                widget.callback(_selectedQuantity, _selectedUnit);
                Navigator.of(context).pop();
              },
              width: MediaQuery.of(context).size.width * .2,
            ),
          ],
        ),
      ),
    );
  }
}
