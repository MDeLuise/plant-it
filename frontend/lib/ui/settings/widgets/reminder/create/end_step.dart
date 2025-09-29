import 'package:flutter/material.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/settings/view_models/reminder/add_reminder_viewmodel.dart';

class EndStep extends StepSection<AddReminderViewModel> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  late final ValueNotifier<DateTime?> _selectedDate =
      ValueNotifier<DateTime?>(null);
  late final ValueNotifier<DateTime?> _ongoingSelection =
      ValueNotifier<DateTime?>(null);

  EndStep({
    super.key,
    required super.viewModel,
    required super.appLocalizations,
  });

  @override
  State<EndStep> createState() => _EndStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  void confirm() {
    viewModel.setEnd(_ongoingSelection.value!);
    _selectedDate.value = _ongoingSelection.value;
  }

  @override
  String get title => appLocalizations.end;

  @override
  String get value => _ongoingSelection.value?.toString() ?? "";

  @override
  void cancel() {
    _ongoingSelection.value = _selectedDate.value;
  }

  @override
  bool get isActionSection => true;

  @override
  Future<void> action(
      BuildContext context, AddReminderViewModel viewModel) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _ongoingSelection.value,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _ongoingSelection.value = picked;
    }
  }
}

class _EndStepState extends State<EndStep> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
