import 'package:flutter/material.dart';
import 'package:plant_it/ui/core/ui/summary/summary_section.dart';
import 'package:plant_it/ui/event/view_models/edit_event_viewmodel.dart';

class NoteSection extends SummarySection<EditEventFormViewModel> {
  final ValueNotifier<bool> _valid = ValueNotifier<bool>(true);
  final ValueNotifier<String?> _selectedNote = ValueNotifier<String?>(null);

  NoteSection({
    super.key,
    required super.viewModel,
  });

  @override
  bool get isActionSection => true;

  @override
  State<NoteSection> createState() => _NoteSectionState();

  @override
  ValueNotifier<bool> get isValidNotifier => _valid;

  @override
  String get title => "Note";

  @override
  String get value {
    final String? note = viewModel.note;
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
    viewModel.setNote(_selectedNote.value!);
  }

  @override
  Future<void> action(
      BuildContext context, EditEventFormViewModel viewmodel) async {
    final TextEditingController controller =
        TextEditingController(text: viewmodel.note ?? "");
    final String? result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Note',
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
      _selectedNote.value = result;
    }
  }
}

class _NoteSectionState extends State<NoteSection> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
