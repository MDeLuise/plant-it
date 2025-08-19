import 'package:flutter/material.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/settings/view_models/add_event_type_viewmodel.dart';

class EventTypeNameStep extends StepSection<AddEventTypeViewModel> {
  final ValueNotifier<String?> name = ValueNotifier(null);
  final ValueNotifier<bool> valid = ValueNotifier(false);

  EventTypeNameStep({super.key, required super.viewModel});

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
  String get title => "Name";

  @override
  String get value => name.value ?? "";
}

class _EventTypeNameStepState extends State<EventTypeNameStep> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .2),
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Insert a name",
            //hint: Center(child: Text("Insert a name")),
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