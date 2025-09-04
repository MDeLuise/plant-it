import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/summary.dart';
import 'package:plant_it/ui/event/view_models/edit_event_viewmodel.dart';
import 'package:plant_it/ui/event/widgets/edit/date_section.dart';
import 'package:plant_it/ui/event/widgets/edit/event_type_section.dart';
import 'package:plant_it/ui/event/widgets/edit/note_section.dart';
import 'package:plant_it/ui/event/widgets/edit/plant_section.dart';

class EditEventScreen extends StatefulWidget {
  final BuildContext appLocalizationsContext;
  final int eventId;
  final EditEventFormViewModel viewModel;

  const EditEventScreen({
    super.key,
    required this.viewModel,
    required this.eventId,
    required this.appLocalizationsContext,
  });

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late final Command<void, void> _mainCommand;
  late final L appLocalizations;

  @override
  void initState() {
    super.initState();
    _mainCommand = Command.createAsyncNoParamNoResult(() async =>
        await widget.viewModel.load.executeWithFuture(widget.eventId));
    _mainCommand.execute();
    appLocalizations = L.of(widget.appLocalizationsContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Summary<EditEventFormViewModel>(
          viewModel: widget.viewModel,
          mainCommand: _mainCommand,
          actionText: L.of(context).update,
          sections: [
            EventTypeSection(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
            PlantSection(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
            DateSection(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
            NoteSection(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
          ],
          actionCommand: widget.viewModel.update,
          mainText: L.of(context).editTheEvent,
          successText: L.of(context).eventUpdated,
          isPrimary: false,
        ));
  }
}
