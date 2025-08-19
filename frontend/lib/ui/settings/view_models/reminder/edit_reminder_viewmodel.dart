import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/event_type_repository.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class EditReminderViewModel extends ChangeNotifier {
  EditReminderViewModel({
    required EventTypeRepository eventTypeRepository,
  }) : _eventTypeRepository = eventTypeRepository {
    load = Command.createAsyncNoResult((int id) async {
      Result<void> result = await _load(id);
      if (result.isError()) throw result.exceptionOrNull()!;
    });
    update = Command.createAsyncNoParam(() async {
      Result<void> result = await _update();
      if (result.isError()) throw result.exceptionOrNull()!;
    }, initialValue: Failure(Exception("not started")));
  }

  final EventTypeRepository _eventTypeRepository;
  final _log = Logger('EditReminderViewModel');
  RemindersCompanion _remindersCompanion = RemindersCompanion();

  late final Command<int, void> load;
  late final Command<void, void> update;

  // String get type => _remindersCompanion.type.value;
  // String? get plant => _remindersCompanion.description.value;
  // String get start => _remindersCompanion.color.value;
  // String get end => _remindersCompanion.icon.value;
  // String get frequencyUnit => _remindersCompanion.icon.value;
  // String get frequencyQuantity => _remindersCompanion.icon.value;
  // String get repeatAfterUnit => _remindersCompanion.icon.value;
  // String get repeatAfterQuantity => _remindersCompanion.icon.value;
  // String get enabled => _remindersCompanion.icon.value;

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

  Future<Result<void>> _load(int id) async {
    // Result<EventType> eventType = await _eventTypeRepository.get(id);
    // if (eventType.isError()) return eventType;
    // _remindersCompanion = eventType.getOrThrow().toCompanion(true);
    // _log.fine("Event type loaded");
    return Success("ok");
  }

  Future<Result<void>> _update() async {
    //return _eventTypeRepository.update(_eventTypesCompanion);
    return Success("ok");
  }
}
