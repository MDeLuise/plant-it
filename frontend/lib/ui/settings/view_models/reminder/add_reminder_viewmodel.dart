import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/reminder_repository.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class AddReminderViewModel extends ChangeNotifier {
  AddReminderViewModel({
    required ReminderRepository reminderRepository,
  }) : _reminderRepository = reminderRepository {
    insert = Command.createAsyncNoParam(() async {
      Result<void> result = await _insert();
      if (result.isError()) throw result.exceptionOrNull()!;
    }, initialValue: Failure(Exception("not started")));
  }

  final ReminderRepository _reminderRepository;
  final _log = Logger('AddReminderViewModel');
  RemindersCompanion _remindersCompanion = RemindersCompanion();

  late final Command<void, void> insert;

  void setType(EventType eventType) {
    _remindersCompanion =
        _remindersCompanion.copyWith(type: Value(eventType.id));
  }

  void setPlant(Plant plant) {
    _remindersCompanion = _remindersCompanion.copyWith(plant: Value(plant.id));
  }

  void setStart(DateTime start) {
    _remindersCompanion = _remindersCompanion.copyWith(startDate: Value(start));
  }

  void setEnd(DateTime end) {
    _remindersCompanion = _remindersCompanion.copyWith(endDate: Value(end));
  }

  void setFrequencyUnit(FrequencyUnit unit) {
    _remindersCompanion =
        _remindersCompanion.copyWith(frequencyUnit: Value(unit));
  }

  void setFrequencyQuantity(int quantity) {
    _remindersCompanion =
        _remindersCompanion.copyWith(frequencyQuantity: Value(quantity));
  }

  void setRepeatAfterUnit(FrequencyUnit unit) {
    _remindersCompanion =
        _remindersCompanion.copyWith(repeatAfterUnit: Value(unit));
  }

  void setRepeatAfterQuantity(int quantity) {
    _remindersCompanion =
        _remindersCompanion.copyWith(repeatAfterQuantity: Value(quantity));
  }

  void setEnabled(bool enabled) {
    _remindersCompanion = _remindersCompanion.copyWith(enabled: Value(enabled));
  }

  Future<Result<void>> _insert() async {
    return _reminderRepository.insert(_remindersCompanion);
  }
}
