import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/plant/view_models/add_plant_viewmodel.dart';

class SellerStep extends StepSection<AddPlantViewModel> {
  final L appLocalizations;
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  final ValueNotifier<String?> _selectedSeller = ValueNotifier(null);
  final ValueNotifier<String?> _ongoingSelection = ValueNotifier(null);

  SellerStep({
    super.key,
    required super.viewModel,
    required this.appLocalizations,
  });

  @override
  State<SellerStep> createState() => _SellerStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  void confirm() {
    viewModel.setSeller(_ongoingSelection.value!);
    _selectedSeller.value = _ongoingSelection.value;
  }

  @override
  String get title => appLocalizations.seller;

  @override
  String get value {
    String location = _ongoingSelection.value ?? "";
    if (location.length > 20) {
      location = "${location.substring(0, 20)}...";
    }
    return location.replaceAll("\n", " ");
  }

  @override
  void cancel() {
    _ongoingSelection.value = _selectedSeller.value;
  }

  @override
  bool get isActionSection => true;

  @override
  Future<void> action(BuildContext context, AddPlantViewModel viewModel) async {
    final TextEditingController controller =
        TextEditingController(text: _ongoingSelection.value ?? "");
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: L.of(context).seller,
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
      _ongoingSelection.value = result;
    }
  }
}

class _SellerStepState extends State<SellerStep> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
