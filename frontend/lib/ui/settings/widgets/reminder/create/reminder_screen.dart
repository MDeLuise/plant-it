import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';
import 'package:plant_it/ui/settings/view_models/reminder/add_reminder_viewmodel.dart';
import 'package:plant_it/ui/settings/widgets/event_type/create/color_step.dart';
import 'package:plant_it/ui/settings/widgets/event_type/create/description_step.dart';
import 'package:plant_it/ui/settings/widgets/event_type/create/icon_step.dart';
import 'package:plant_it/ui/settings/widgets/event_type/create/name_step.dart';

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
        mainCommand: Command.createAsyncNoParamNoResult(() => Future.value()),
        actionText: "Create",
        steps: [
          // EventTypeNameStep(viewModel: widget.viewModel),
          // IconStep(viewModel: widget.viewModel),
          // ColorStep(viewModel: widget.viewModel),
          // DescriptionStep(viewModel: widget.viewModel),
        ],
        stepsInFocus: 3,
        actionCommand: widget.viewModel.insert,
      ),
    );
  }
}
