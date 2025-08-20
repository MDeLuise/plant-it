import 'package:flutter/material.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';
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
        title: Text("Edit reminder"),
      ),
      body: AppStepper<EditReminderViewModel>(
        viewModel: widget.viewModel,
        mainCommand: widget.viewModel.load,
        actionText: "Update",
        steps: [
          EventTypeStep(viewModel: widget.viewModel),
          PlantStep(viewModel: widget.viewModel),
          FrequencyStep(viewModel: widget.viewModel),
          RepeatAfterStep(viewModel: widget.viewModel),
          StartStep(viewModel: widget.viewModel),
          EndStep(viewModel: widget.viewModel),
        ],
        stepsInFocus: 0,
        actionCommand: widget.viewModel.update,
        summary: true,
      ),
    );
  }
}
