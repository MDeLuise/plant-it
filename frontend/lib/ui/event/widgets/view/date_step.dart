import 'package:flutter/material.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';

class DateStep extends StepSection<EventFormViewModel> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  late final ValueNotifier<DateTime?> _selectedDate =
      ValueNotifier<DateTime?>(viewModel.date);
  late final ValueNotifier<DateTime?> _ongoingSelection =
      ValueNotifier<DateTime?>(viewModel.date);

  DateStep({
    super.key,
    required super.viewModel,
  });

  @override
  State<DateStep> createState() => _DateStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  void confirm() {
    viewModel.setDate(_ongoingSelection.value!);
    _selectedDate.value = _ongoingSelection.value;
  }

  @override
  String get title => "Date";

  @override
  String get value => _ongoingSelection.value!.toString();

  @override
  void cancel() {
    _ongoingSelection.value = _selectedDate.value;
  }

  @override
  bool get isActionSection => true;

  @override
  Future<void> action(
      BuildContext context, EventFormViewModel viewModel) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: viewModel.date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _ongoingSelection.value = picked;
    }
  }
}

class _DateStepState extends State<DateStep> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
