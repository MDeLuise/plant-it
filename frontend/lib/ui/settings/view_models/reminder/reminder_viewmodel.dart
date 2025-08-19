import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/event_type_repository.dart';
import 'package:plant_it/data/repository/plant_repository.dart';
import 'package:plant_it/data/repository/reminder_repository.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class ReminderViewModel extends ChangeNotifier {
  ReminderViewModel({
    required ReminderRepository reminderRepository,
    required EventTypeRepository eventTypeRepository,
    required PlantRepository plantRepository,
  })  : _reminderRepository = reminderRepository,
        _eventTypeRepository = eventTypeRepository,
        _plantRepository = plantRepository {
    load = Command.createAsyncNoParam(() async {
      Result<void> result = await _load();
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
    delete = Command.createAsync((int id) async {
      Result<void> result = await _delete(id);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
  }

  final ReminderRepository _reminderRepository;
  final EventTypeRepository _eventTypeRepository;
  final PlantRepository _plantRepository;
  final _log = Logger('ReminderViewModel');

  late final Command<void, void> load;
  late final Command<int, void> delete;

  List<Reminder> _reminders = [];
  final Map<int, EventType> _eventTypes = {};
  final Map<int, Plant> _plants = {};

  List<Reminder> get reminders => _reminders;
  Map<int, EventType> get eventTypes => _eventTypes;
  Map<int, Plant> get plants => _plants;

  Future<Result<void>> _load() async {
    final reminders = await _reminderRepository.getAll();
    if (reminders.isError()) {
      return reminders.exceptionOrNull()!.toFailure();
    }
    _reminders = reminders.getOrThrow();
    _log.fine('Loaded reminders');

    final eventTypes = await _eventTypeRepository.getAll();
    if (eventTypes.isError()) {
      return eventTypes.exceptionOrNull()!.toFailure();
    }
    for (EventType et in eventTypes.getOrThrow()) {
      _eventTypes.putIfAbsent(et.id, () => et);
    }
    _log.fine('Loaded event types');

    final plants = await _plantRepository.getAll();
    if (plants.isError()) {
      return plants.exceptionOrNull()!.toFailure();
    }
    for (Plant p in plants.getOrThrow()) {
      _plants.putIfAbsent(p.id, () => p);
    }
    _log.fine('Loaded plants');

    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _delete(int id) async {
    return _reminderRepository.delete(id);
  }
}
