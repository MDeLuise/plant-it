import 'package:flutter/material.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/settings/view_models/event_type/edit_event_type_viewmodel.dart';

class DescriptionStep extends StepSection<EditEventTypeViewModel> {
  final AppLocalizations appLocalizations;
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  late final ValueNotifier<String?> _selectedNote = ValueNotifier(viewModel.description);
  late final ValueNotifier<String?> _ongoingSelection = ValueNotifier(viewModel.description);

  DescriptionStep({
    super.key,
    required super.viewModel,
    required this.appLocalizations,
  });

  @override
  State<DescriptionStep> createState() => _DescriptionStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  void confirm() {
    viewModel.setDescription(_ongoingSelection.value!);
    _selectedNote.value = _ongoingSelection.value;
  }

  @override
  String get title => appLocalizations.description;

  @override
  String get value {
    String note = _ongoingSelection.value ?? "";
    if (note.length > 20) {
      note = "${note.substring(0, 20)}...";
    }
    return note.replaceAll("\n", " ");
  }

  @override
  void cancel() {
    _ongoingSelection.value = _selectedNote.value;
  }

  @override
  bool get isActionSection => true;

  @override
  Future<void> action(
      BuildContext context, EditEventTypeViewModel viewModel) async {
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
              labelText: AppLocalizations.of(context)!.description,
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

class _DescriptionStepState extends State<DescriptionStep> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
