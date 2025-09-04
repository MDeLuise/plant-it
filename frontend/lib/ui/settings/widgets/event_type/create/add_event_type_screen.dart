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
  final BuildContext appLocalizationsContext;
  final AddEventTypeViewModel viewModel;

  const AddEventTypeScreen({
    super.key,
    required this.viewModel,
    required this.appLocalizationsContext,
  });

  @override
  State<AddEventTypeScreen> createState() => _AddEventTypeScreenState();
}

class _AddEventTypeScreenState extends State<AddEventTypeScreen> {
  late final AppLocalizations _appLocalizations;

  @override
  void initState() {
    super.initState();
    _appLocalizations = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.createEventType),
      ),
      body: AppStepper<AddEventTypeViewModel>(
        viewModel: widget.viewModel,
        mainCommand: Command.createAsyncNoParamNoResult(() => Future.value()),
        actionText: _appLocalizations.create,
        steps: [
          EventTypeNameStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
          IconStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
          ColorStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
          DescriptionStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
        ],
        stepsInFocus: 3,
        actionCommand: widget.viewModel.insert,
        successText: _appLocalizations.eventCreated,
      ),
    );
  }
}
