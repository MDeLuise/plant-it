import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';
import 'package:plant_it/ui/event/widgets/create/date_step.dart';
import 'package:plant_it/ui/event/widgets/create/plant_step.dart';
import 'package:plant_it/ui/event/widgets/create/event_type_step.dart';
import 'package:plant_it/ui/event/widgets/create/note_step.dart';

class CreateEventScreen extends StatefulWidget {
  final BuildContext appLocalizationsContext;
  final CreateEventFormViewModel viewModel;

  const CreateEventScreen({
    super.key,
    required this.viewModel,
    required this.appLocalizationsContext,
  });

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  late final AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
    appLocalizations = AppLocalizations.of(widget.appLocalizationsContext)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: Text(AppLocalizations.of(context)!.createEvent),
      ),
      body: AppStepper<CreateEventFormViewModel>(
          viewModel: widget.viewModel,
          mainCommand: widget.viewModel.load,
          actionText: AppLocalizations.of(context)!.create,
          actionCommand: widget.viewModel.insert,
          successText: AppLocalizations.of(context)!.eventsCreated,
          summary: true,
          stepsInFocus: 2,
          steps: [
            EventTypeStep(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
            PlantStep(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
            DateStep(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
            NoteStep(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
          ]),
    );
  }
}
