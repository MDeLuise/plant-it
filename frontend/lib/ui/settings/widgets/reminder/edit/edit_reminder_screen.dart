import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
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
  late final L _appLocalizations;

  @override
  void initState() {
    super.initState();
    _appLocalizations = L.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appLocalizations.editReminder),
      ),
      body: Summary<EditReminderViewModel>(
        viewModel: widget.viewModel,
        mainCommand: widget.viewModel.load,
        actionText: _appLocalizations.update,
        sections: [
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
        actionCommand: widget.viewModel.update,
        successText: _appLocalizations.reminderUpdated,
        isPrimary: false,
      ),
    );
  }
}
