import 'package:flutter/material.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/plant/view_models/edit_plant_viewmodel.dart';

class NameStep extends StepSection<EditPlantViewModel> {
  final AppLocalizations appLocalizations;
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);
  late final ValueNotifier<String?> _selectedName =
      ValueNotifier(viewModel.name);
  late final ValueNotifier<String?> _ongoingSelection =
      ValueNotifier(viewModel.name);

  NameStep({
    super.key,
    required super.viewModel,
    required this.appLocalizations,
  });

  @override
  State<NameStep> createState() => _NameStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  void confirm() {
    viewModel.setName(_ongoingSelection.value!);
    _selectedName.value = _ongoingSelection.value;
  }

  @override
  String get title => appLocalizations.name;

  @override
  String get value {
    String name = _ongoingSelection.value ?? "";
    if (name.length > 20) {
      name = "${name.substring(0, 20)}...";
    }
    return name.replaceAll("\n", " ");
  }

  @override
  void cancel() {
    _ongoingSelection.value = _selectedName.value;
  }

  @override
  bool get isActionSection => true;

  @override
  Future<void> action(BuildContext context, EditPlantViewModel viewModel) async {
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
              labelText: AppLocalizations.of(context)!.name,
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
      _isValidNotifier.value = result.isNotEmpty;
    }
  }
}

class _NameStepState extends State<NameStep> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
