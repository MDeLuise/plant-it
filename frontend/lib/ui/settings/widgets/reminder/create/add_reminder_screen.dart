import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Create reminder"),
      ),
      body: AppStepper<AddReminderViewModel>(
        viewModel: widget.viewModel,
        mainCommand: widget.viewModel.load,
        actionText: "Create",
        steps: [
          EventTypeStep(viewModel: widget.viewModel),
          PlantStep(viewModel: widget.viewModel),
          FrequencyStep(viewModel: widget.viewModel),
          RepeatAfterStep(viewModel: widget.viewModel),
          StartStep(viewModel: widget.viewModel),
          EndStep(viewModel: widget.viewModel),
        ],
        stepsInFocus: 2,
        actionCommand: widget.viewModel.insert,
        summary: true,
        successText: "Reminder created",
      ),
    );
  }
}
