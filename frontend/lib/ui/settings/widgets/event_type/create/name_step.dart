import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/settings/view_models/event_type/add_event_type_viewmodel.dart';

class EventTypeNameStep extends StepSection<AddEventTypeViewModel> {
  final ValueNotifier<String?> name = ValueNotifier(null);
  final ValueNotifier<bool> valid = ValueNotifier(false);

  EventTypeNameStep({
    super.key,
    required super.viewModel,
    required super.appLocalizations,
  });

  @override
  void cancel() {}

  @override
  void confirm() {
    viewModel.setName(name.value!);
  }

  @override
  State<StatefulWidget> createState() => _EventTypeNameStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => valid;

  @override
  String get title => appLocalizations.name;

  @override
  String get value => name.value ?? "";
}

class _EventTypeNameStepState extends State<EventTypeNameStep> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .2),
        child: TextField(
          controller: _nameController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: L.of(context).insertAName,
          ),
          onChanged: (value) {
            widget.name.value = value;
            widget.isValidNotifier.value = value.isNotEmpty;
          },
        ),
      ),
    );
  }
}
