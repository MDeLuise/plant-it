import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';
import 'package:plant_it/ui/settings/view_models/reminder/add_reminder_viewmodel.dart';
import 'package:plant_it/ui/settings/widgets/reminder/create/end_step.dart';
import 'package:plant_it/ui/settings/widgets/reminder/create/event_type_step.dart';
import 'package:plant_it/ui/settings/widgets/reminder/create/frequency_step.dart';
import 'package:plant_it/ui/settings/widgets/reminder/create/plant_step.dart';
import 'package:plant_it/ui/settings/widgets/reminder/create/repeat_after_step.dart';
import 'package:plant_it/ui/settings/widgets/reminder/create/start_step.dart';

class AddReminderScreen extends StatefulWidget {
  final AddReminderViewModel viewModel;

  const AddReminderScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  late final L _appLocalizations;

  @override
  void initState() {
    super.initState();
    _appLocalizations = L.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appLocalizations.createReminder),
      ),
      body: AppStepper<AddReminderViewModel>(
        viewModel: widget.viewModel,
        mainCommand: widget.viewModel.load,
        actionText: _appLocalizations.create,
        steps: [
          EventTypeStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
          PlantStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
          FrequencyStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
          RepeatAfterStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
          StartStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
          EndStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
        ],
        stepsInFocus: 2,
        actionCommand: widget.viewModel.insert,
        summary: true,
        successText: _appLocalizations.reminderCreated,
      ),
    );
  }
}
