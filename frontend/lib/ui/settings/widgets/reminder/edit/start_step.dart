import 'package:flutter/material.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/settings/view_models/reminder/edit_reminder_viewmodel.dart';

class StartStep extends StepSection<EditReminderViewModel> {
  final AppLocalizations appLocalizations;
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  late final ValueNotifier<DateTime> _selectedDate =
      ValueNotifier<DateTime>(viewModel.startDate);
  late final ValueNotifier<DateTime> _ongoingSelection =
      ValueNotifier<DateTime>(viewModel.startDate);

  StartStep({
    super.key,
    required super.viewModel,
    required this.appLocalizations,
  });

  @override
  State<StartStep> createState() => _StartStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  void confirm() {
    viewModel.setStart(_ongoingSelection.value);
    _selectedDate.value = _ongoingSelection.value;
  }

  @override
  String get title => "Start";

  @override
  String get value => _ongoingSelection.value.toString();

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

class _StartStepState extends State<StartStep> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
