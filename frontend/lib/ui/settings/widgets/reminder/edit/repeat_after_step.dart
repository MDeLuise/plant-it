import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/settings/view_models/reminder/edit_reminder_viewmodel.dart';

class RepeatAfterStep extends StepSection<EditReminderViewModel> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  late final ValueNotifier<FrequencyUnit> _selectedFrequencyUnit =
      ValueNotifier(viewModel.repeatAfterUnit);
  late final ValueNotifier<int> _selectedFrequencyQuantity =
      ValueNotifier(viewModel.repeatAfterQuantity);
  late final ValueNotifier<FrequencyUnit> _ongoingFrequencyUnit =
      ValueNotifier(viewModel.repeatAfterUnit);
  late final ValueNotifier<int> _ongoingFrequencyQuantity =
      ValueNotifier(viewModel.repeatAfterQuantity);

  RepeatAfterStep({
    super.key,
    required super.viewModel,
  });

  @override
  State<RepeatAfterStep> createState() => _RepeatAfterStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  void confirm() {
    viewModel.setFrequencyUnit(_ongoingFrequencyUnit.value);
    viewModel.setFrequencyQuantity(_ongoingFrequencyQuantity.value);
    _selectedFrequencyUnit.value = _ongoingFrequencyUnit.value;
    _selectedFrequencyQuantity.value = _ongoingFrequencyQuantity.value;
  }

  @override
  String get title => "Repeat after";

  @override
  String get value =>
      "${_ongoingFrequencyQuantity.value} ${_ongoingFrequencyUnit.value.name}";

  @override
  void cancel() {
    _ongoingFrequencyUnit.value = _selectedFrequencyUnit.value;
    _ongoingFrequencyQuantity.value = _selectedFrequencyQuantity.value;
  }

  @override
  bool get isActionSection => true;

  @override
  Future<void> action(
      BuildContext context, EditReminderViewModel viewModel) async {
    final TextEditingController controller =
        TextEditingController(text: _ongoingFrequencyQuantity.value.toString());
    final FrequencyUnit currentFrequencyUnit = _ongoingFrequencyUnit.value;

    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                autofocus: true,
              ),
              ValueListenableBuilder<FrequencyUnit>(
                valueListenable: _ongoingFrequencyUnit,
                builder: (context, selectedUnit, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: FrequencyUnit.values.map((unit) {
                      return Row(
                        children: [
                          Radio<FrequencyUnit>(
                            value: unit,
                            groupValue: selectedUnit,
                            onChanged: (FrequencyUnit? value) {
                              if (value != null) {
                                _ongoingFrequencyUnit.value = value;
                              }
                            },
                          ),
                          Text(unit.name.substring(0, 1).toUpperCase()),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _ongoingFrequencyUnit.value = currentFrequencyUnit;
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );

    if (result != null) {
      _ongoingFrequencyQuantity.value = int.tryParse(result) ?? 1;
    }
  }
}

class _RepeatAfterStepState extends State<RepeatAfterStep> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
