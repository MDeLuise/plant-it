import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/event/view_models/edit_event_viewmodel.dart';

class NoteSection extends StepSection<EditEventFormViewModel> {
  final ValueNotifier<bool> _valid = ValueNotifier<bool>(true);
  late final ValueNotifier<String?> _selectedNote =
      ValueNotifier<String?>(viewModel.note);
  late final ValueNotifier<String?> _ongoingSelection =
      ValueNotifier<String?>(viewModel.note);

  NoteSection({
    super.key,
    required super.viewModel,
    required super.appLocalizations,
  });

  @override
  bool get isActionSection => true;

  @override
  State<NoteSection> createState() => _NoteSectionState();

  @override
  ValueNotifier<bool> get isValidNotifier => _valid;

  @override
  String get title => appLocalizations.note;

  @override
  String get value {
    final String? note = _ongoingSelection.value;
    if (note == null) {
      return "";
    }
    if (note.length > 20) {
      return "${note.substring(0, 20).replaceAll('\n', " ")}...";
    }
    return note.replaceAll('\n', " ");
  }

  @override
  void confirm() {
    if (_selectedNote.value == null) {
      return;
    }
    viewModel.setNote(_ongoingSelection.value!);
    _selectedNote.value = _ongoingSelection.value;
  }

  @override
  void cancel() {
    _ongoingSelection.value = _selectedNote.value;
  }

  @override
  Future<void> action(
      BuildContext context, EditEventFormViewModel viewModel) async {
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
              labelText: L.of(context).note,
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

class _NoteSectionState extends State<NoteSection> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
