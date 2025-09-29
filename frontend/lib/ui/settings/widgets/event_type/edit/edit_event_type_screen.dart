import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/summary.dart';
import 'package:plant_it/ui/settings/view_models/event_type/edit_event_type_viewmodel.dart';
import 'package:plant_it/ui/settings/widgets/event_type/edit/color_step.dart';
import 'package:plant_it/ui/settings/widgets/event_type/edit/description_step.dart';
import 'package:plant_it/ui/settings/widgets/event_type/edit/icon_step.dart';
import 'package:plant_it/ui/settings/widgets/event_type/edit/name_step.dart';

class EditEventTypeScreen extends StatefulWidget {
  final EditEventTypeViewModel viewModel;

  const EditEventTypeScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<EditEventTypeScreen> createState() => _EditEventTypeScreenState();
}

class _EditEventTypeScreenState extends State<EditEventTypeScreen> {
  @override
  Widget build(BuildContext context) {
    L appLocalizations = L.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.editEventType),
      ),
      body: Summary<EditEventTypeViewModel>(
        viewModel: widget.viewModel,
        mainCommand: widget.viewModel.load,
        actionText: appLocalizations.update,
        sections: [
          EventTypeNameStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
          IconStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
          ColorStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
          DescriptionStep(
            viewModel: widget.viewModel,
            appLocalizations: appLocalizations,
          ),
        ],
        actionCommand: widget.viewModel.update,
        successText: appLocalizations.eventTypeUpdated,
        isPrimary: false,
      ),
    );
  }
}
