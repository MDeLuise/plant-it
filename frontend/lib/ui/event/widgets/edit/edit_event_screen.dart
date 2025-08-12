import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/ui/core/ui/summary/summary.dart';
import 'package:plant_it/ui/event/view_models/edit_event_viewmodel.dart';
import 'package:plant_it/ui/event/widgets/edit/date_section.dart';
import 'package:plant_it/ui/event/widgets/edit/event_type_section.dart';
import 'package:plant_it/ui/event/widgets/edit/note_section.dart';
import 'package:plant_it/ui/event/widgets/edit/plant_section.dart';

class EditEventScreen extends StatefulWidget {
  final int eventId;
  final EditEventFormViewModel viewModel;

  const EditEventScreen({
    super.key,
    required this.viewModel,
    required this.eventId,
  });

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late final Command<void, void> _mainCommand;
  
  @override
  void initState() {
    super.initState();
    _mainCommand = Command.createAsyncNoParamNoResult(
              () async => await widget.viewModel.load.executeWithFuture(widget.eventId));
    _mainCommand.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Summary<EditEventFormViewModel>(
          viewModel: widget.viewModel,
          mainCommand: _mainCommand,
          actionText: "Update",
          sections: [
            EventTypeSection(viewModel: widget.viewModel),
            PlantSection(viewModel: widget.viewModel),
            DateSection(viewModel: widget.viewModel),
            NoteSection(viewModel: widget.viewModel),
          ],
          actionCommand:  widget.viewModel.update,
          mainText: "Edit the event",
        ));
  }
}
