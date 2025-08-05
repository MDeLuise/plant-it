import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/ui/core/ui/stepper/stepper.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';
import 'package:plant_it/ui/event/widgets/date_and_note_step.dart';
import 'package:plant_it/ui/event/widgets/event_plant_step.dart';
import 'package:plant_it/ui/event/widgets/event_type_step.dart';

class EventScreen extends StatefulWidget {
  final EventFormViewModel viewModel;

  const EventScreen({super.key, required this.viewModel});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text('Create Event'),
      ),
      body: AppStepper(
          viewModel: widget.viewModel,
          mainCommand: widget.viewModel.load,
          actionText: "Create",
          actionCommand: widget.viewModel.insert,
          successText: "Events created",
          steps: [
            EventTypeStep(viewModel: widget.viewModel),
            EventPlantStep(viewModel: widget.viewModel),
            DateAndNoteStep(viewModel: widget.viewModel),
          ]),
    );
  }
}
