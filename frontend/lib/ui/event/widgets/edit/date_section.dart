import 'package:flutter/material.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/event/view_models/edit_event_viewmodel.dart';

class DateSection extends StepSection<EditEventFormViewModel> {
  final AppLocalizations appLocalizations;
  final ValueNotifier<bool> _valid = ValueNotifier<bool>(true);
  late final ValueNotifier<DateTime?> _selectedDate =
      ValueNotifier<DateTime?>(viewModel.date);
  late final ValueNotifier<DateTime?> _ongoingSelection =
      ValueNotifier<DateTime?>(viewModel.date);

  DateSection({
    super.key,
    required super.viewModel,
    required this.appLocalizations,
  });

  @override
  bool get isActionSection => true;

  @override
  State<DateSection> createState() => _DateSectionState();

  @override
  ValueNotifier<bool> get isValidNotifier => _valid;

  @override
  String get title => appLocalizations.note;

  @override
  String get value => _ongoingSelection.value.toString();

  @override
  void confirm() {
    if (_ongoingSelection.value == null) {
      return;
    }
    viewModel.setDate(_ongoingSelection.value!);
    _selectedDate.value = _ongoingSelection.value;
  }

  @override
  void cancel() {
    _ongoingSelection.value = _selectedDate.value;
  }

  @override
  Future<void> action(
      BuildContext context, EditEventFormViewModel viewModel) async {
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

class _DateSectionState extends State<DateSection> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
