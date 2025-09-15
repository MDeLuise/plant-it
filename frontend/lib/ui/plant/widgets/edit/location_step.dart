import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/plant/view_models/edit_plant_viewmodel.dart';

class LocationStep extends StepSection<EditPlantViewModel> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  late final ValueNotifier<String?> _selectedLocation =
      ValueNotifier(viewModel.location);
  late final ValueNotifier<String?> _ongoingSelection =
      ValueNotifier(viewModel.location);

  LocationStep({
    super.key,
    required super.viewModel,
    required super.appLocalizations,
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
  String get title => appLocalizations.location;

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
  Future<void> action(
      BuildContext context, EditPlantViewModel viewModel) async {
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
              labelText: L.of(context).location,
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

class _LocationStepState extends State<LocationStep> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
