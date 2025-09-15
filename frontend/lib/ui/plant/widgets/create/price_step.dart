import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/plant/view_models/add_plant_viewmodel.dart';

class PriceStep extends StepSection<AddPlantViewModel> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  final ValueNotifier<double?> _selectedPrice = ValueNotifier(null);
  final ValueNotifier<double?> _ongoingSelection = ValueNotifier(null);

  PriceStep({
    super.key,
    required super.viewModel,
    required super.appLocalizations,
  });

  @override
  State<PriceStep> createState() => _PriceStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  void confirm() {
    viewModel.setPrice(_ongoingSelection.value!);
    _selectedPrice.value = _ongoingSelection.value;
  }

  @override
  String get title => appLocalizations.price;

  @override
  String get value => _ongoingSelection.value?.toString() ?? "";

  @override
  void cancel() {
    _ongoingSelection.value = _selectedPrice.value;
  }

  @override
  bool get isActionSection => true;

  @override
  Future<void> action(BuildContext context, AddPlantViewModel viewModel) async {
    final TextEditingController controller =
        TextEditingController(text: _ongoingSelection.value?.toString() ?? "");
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: L.of(context).price,
              border: OutlineInputBorder(),
            ),
            maxLines: null,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(L.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text(L.of(context).save),
            ),
          ],
        );
      },
    );

    if (result != null) {
      _ongoingSelection.value = double.parse(result.replaceAll(",", "."));
    }
  }
}

class _PriceStepState extends State<PriceStep> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
