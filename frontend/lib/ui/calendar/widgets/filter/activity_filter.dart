import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/calendar/widgets/filter/event_type_step.dart';
import 'package:plant_it/ui/calendar/widgets/filter/plant_step.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';

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
    L appLocalizations = L.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            await widget.viewModel.clearFilter.executeWithFuture();
            context.pop();
          },
        ),
        title: Text(appLocalizations.filterActivities),
      ),
      body: AppStepper(
        viewModel: widget.viewModel,
        mainCommand: widget.viewModel.load,
        actionText: appLocalizations.filter,
        actionCommand: widget.viewModel.filter,
        stepsInFocus: 0,
        steps: [
          PlantStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
          EventTypeStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
        ],
      ),
    );
  }
}
