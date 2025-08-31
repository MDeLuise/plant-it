import 'package:flutter/material.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/plant/view_models/add_plant_viewmodel.dart';

class LocationStep extends StepSection<AddPlantViewModel> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  final ValueNotifier<String?> _selectedLocation = ValueNotifier(null);
  final ValueNotifier<String?> _ongoingSelection = ValueNotifier(null);

  LocationStep({
    super.key,
    required super.viewModel,
  });

  @override
  State<LocationStep> createState() => _LocationStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  void confirm() {
    viewModel.setLocation(_ongoingSelection.value!);
    _selectedLocation.value = _ongoingSelection.value;
  }

  @override
  String get title => "Location";

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
    _ongoingSelection.value = _selectedLocation.value;
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
              labelText: AppLocalizations.of(context)!.location,
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
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text(AppLocalizations.of(context)!.save),
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

class _LocationStepState extends State<LocationStep> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
