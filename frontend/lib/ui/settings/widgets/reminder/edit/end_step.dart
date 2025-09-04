import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/settings/view_models/reminder/edit_reminder_viewmodel.dart';

class EndStep extends StepSection<EditReminderViewModel> {
  final L appLocalizations;
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  late final ValueNotifier<DateTime?> _selectedDate =
      ValueNotifier<DateTime?>(viewModel.endDate);
  late final ValueNotifier<DateTime?> _ongoingSelection =
      ValueNotifier<DateTime?>(viewModel.endDate);

  EndStep({
    super.key,
    required super.viewModel,
    required this.appLocalizations,
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
  String get title => "End";

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
      BuildContext context, EditReminderViewModel viewModel) async {
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
