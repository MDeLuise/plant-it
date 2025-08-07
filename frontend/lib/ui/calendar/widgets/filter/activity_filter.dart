import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/calendar/widgets/filter/event_type_step.dart';
import 'package:plant_it/ui/calendar/widgets/filter/plant_step.dart';
import 'package:plant_it/ui/core/ui/stepper/stepper.dart';

class ActivityFilter extends StatefulWidget {
  final CalendarViewModel viewModel;
  const ActivityFilter({
    super.key,
    required this.viewModel,
  });

  @override
  State<ActivityFilter> createState() => _ActivityFilterState();
}

class _ActivityFilterState extends State<ActivityFilter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            await widget.viewModel.clearFilter.executeWithFuture();
            context.pop();
          },
        ),
        title: const Text('Filter activities'),
      ),
      body: AppStepper(
          viewModel: widget.viewModel,
          mainCommand: widget.viewModel.load,
          actionText: "Filter",
          actionCommand: widget.viewModel.filter,
          steps: [
            PlantStep(viewModel: widget.viewModel),
            EventTypeStep(viewModel: widget.viewModel),
            ]),
    );
  }
}
