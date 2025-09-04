import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/plant/view_models/add_plant_viewmodel.dart';

class StartDateStep extends StepSection<AddPlantViewModel> {
  final L appLocalizations;
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  final ValueNotifier<DateTime?> _selectedDate = ValueNotifier<DateTime?>(null);
  final ValueNotifier<DateTime?> _ongoingSelection =
      ValueNotifier<DateTime?>(null);

  StartDateStep({
    super.key,
    required super.viewModel,
    required this.appLocalizations,
  });

  @override
  State<StartDateStep> createState() => _StartDateStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  void confirm() {
    viewModel.setStartDate(_ongoingSelection.value!);
    _selectedDate.value = _ongoingSelection.value;
  }

  @override
  String get title => appLocalizations.date;

  @override
  String get value => _ongoingSelection.value?.toString() ?? "";

  @override
  void cancel() {
    _ongoingSelection.value = _selectedDate.value;
  }

  @override
  bool get isActionSection => true;

  @override
  Future<void> action(BuildContext context, AddPlantViewModel viewModel) async {
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

class _StartDateStepState extends State<StartDateStep> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
