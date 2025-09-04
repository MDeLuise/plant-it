import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/calendar/widgets/filter/event_type_step.dart';
import 'package:plant_it/ui/calendar/widgets/filter/plant_step.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';

class ActivityFilter extends StatefulWidget {
  final BuildContext appLocalizationsContext;
  final CalendarViewModel viewModel;

  const ActivityFilter({
    super.key,
    required this.viewModel,
    required this.appLocalizationsContext,
  });

  @override
  State<ActivityFilter> createState() => _ActivityFilterState();
}

class _ActivityFilterState extends State<ActivityFilter> {
  late L _appLocalizations;

  @override
  void initState() {
    super.initState();
    _appLocalizations = L.of(widget.appLocalizationsContext)!;
  }

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
        title: Text(L.of(context).filterActivities),
      ),
      body: AppStepper(
        viewModel: widget.viewModel,
        mainCommand: widget.viewModel.load,
        actionText: L.of(context).filter,
        actionCommand: widget.viewModel.filter,
        stepsInFocus: 0,
        steps: [
          PlantStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
          EventTypeStep(
            viewModel: widget.viewModel,
            appLocalizations: _appLocalizations,
          ),
        ],
      ),
    );
  }
}
