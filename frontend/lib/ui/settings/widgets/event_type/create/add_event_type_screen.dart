import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';
import 'package:plant_it/ui/settings/view_models/event_type/add_event_type_viewmodel.dart';
import 'package:plant_it/ui/settings/widgets/event_type/create/color_step.dart';
import 'package:plant_it/ui/settings/widgets/event_type/create/description_step.dart';
import 'package:plant_it/ui/settings/widgets/event_type/create/icon_step.dart';
import 'package:plant_it/ui/settings/widgets/event_type/create/name_step.dart';

class AddEventTypeScreen extends StatefulWidget {
  final AddEventTypeViewModel viewModel;

  const AddEventTypeScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<AddEventTypeScreen> createState() => _AddEventTypeScreenState();
}

class _AddEventTypeScreenState extends State<AddEventTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createEventType),
      ),
      body: AppStepper<AddEventTypeViewModel>(
        viewModel: widget.viewModel,
        mainCommand: Command.createAsyncNoParamNoResult(() => Future.value()),
        actionText: AppLocalizations.of(context)!.create,
        steps: [
          EventTypeNameStep(viewModel: widget.viewModel),
          IconStep(viewModel: widget.viewModel),
          ColorStep(viewModel: widget.viewModel),
          DescriptionStep(viewModel: widget.viewModel),
        ],
        stepsInFocus: 3,
        actionCommand: widget.viewModel.insert,
        successText: AppLocalizations.of(context)!.eventCreated,
      ),
    );
  }
}
