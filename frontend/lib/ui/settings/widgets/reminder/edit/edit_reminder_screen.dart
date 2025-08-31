import 'package:flutter/material.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/summary.dart';
import 'package:plant_it/ui/settings/view_models/reminder/edit_reminder_viewmodel.dart';
import 'package:plant_it/ui/settings/widgets/reminder/edit/end_step.dart';
import 'package:plant_it/ui/settings/widgets/reminder/edit/event_type_step.dart';
import 'package:plant_it/ui/settings/widgets/reminder/edit/frequency_step.dart';
import 'package:plant_it/ui/settings/widgets/reminder/edit/plant_step.dart';
import 'package:plant_it/ui/settings/widgets/reminder/edit/repeat_after_step.dart';
import 'package:plant_it/ui/settings/widgets/reminder/edit/start_step.dart';

class EditReminderScreen extends StatefulWidget {
  final EditReminderViewModel viewModel;

  const EditReminderScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<EditReminderScreen> createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editReminder),
      ),
      body: Summary<EditReminderViewModel>(
        viewModel: widget.viewModel,
        mainCommand: widget.viewModel.load,
        actionText: AppLocalizations.of(context)!.update,
        sections: [
          EventTypeStep(viewModel: widget.viewModel),
          PlantStep(viewModel: widget.viewModel),
          FrequencyStep(viewModel: widget.viewModel),
          RepeatAfterStep(viewModel: widget.viewModel),
          StartStep(viewModel: widget.viewModel),
          EndStep(viewModel: widget.viewModel),
        ],
        actionCommand: widget.viewModel.update,
        successText: AppLocalizations.of(context)!.reminderUpdated,
        isPrimary: false,
      ),
    );
  }
}
