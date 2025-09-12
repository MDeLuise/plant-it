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
  @override
  Widget build(BuildContext context) {
    L appLocalizations = L.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.createReminder),
      ),
      body: AppStepper<AddReminderViewModel>(
        viewModel: widget.viewModel,
        mainCommand: widget.viewModel.load,
        actionText: appLocalizations.create,
        steps: [
          EventTypeStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
          PlantStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
          FrequencyStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
          RepeatAfterStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
          StartStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
          EndStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
        ],
        stepsInFocus: 2,
        actionCommand: widget.viewModel.insert,
        summary: true,
        successText: appLocalizations.reminderCreated,
      ),
    );
  }
}
