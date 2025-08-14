import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';
import 'package:plant_it/ui/event/widgets/create/date_step.dart';
import 'package:plant_it/ui/event/widgets/create/plant_step.dart';
import 'package:plant_it/ui/event/widgets/create/event_type_step.dart';
import 'package:plant_it/ui/event/widgets/create/note_step.dart';

class CreateEventScreen extends StatefulWidget {
  final CreateEventFormViewModel viewModel;

  const CreateEventScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text('Create Event'),
      ),
      body: AppStepper<CreateEventFormViewModel>(
          viewModel: widget.viewModel,
          mainCommand: widget.viewModel.load,
          actionText: "Create",
          actionCommand: widget.viewModel.insert,
          successText: "Events created",
          summary: true,
          stepsInFocus: 2,
          steps: [
            EventTypeStep(viewModel: widget.viewModel),
            PlantStep(viewModel: widget.viewModel),
            DateStep(viewModel: widget.viewModel),
            NoteStep(viewModel: widget.viewModel),
          ]),
    );
  }
}
