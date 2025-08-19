import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/event_type_repository.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class EditEventTypeViewModel extends ChangeNotifier {
  EditEventTypeViewModel({
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
  final _log = Logger('EditEventTypeViewModel');
  EventTypesCompanion _eventTypesCompanion = EventTypesCompanion();

  late final Command<int, void> load;
  late final Command<void, void> update;

  String get name => _eventTypesCompanion.name.value;
  String? get description => _eventTypesCompanion.description.value;
  String get color => _eventTypesCompanion.color.value;
  String get icon => _eventTypesCompanion.icon.value;

  void setName(String name) {
    _eventTypesCompanion = _eventTypesCompanion.copyWith(name: Value(name));
  }

  void setDescription(String description) {
    _eventTypesCompanion =
        _eventTypesCompanion.copyWith(description: Value(description));
  }

  void setIcon(String icon) {
    _eventTypesCompanion = _eventTypesCompanion.copyWith(icon: Value(icon));
  }

  void setColor(String color) {
    _eventTypesCompanion = _eventTypesCompanion.copyWith(color: Value(color));
  }

  Future<Result<void>> _load(int id) async {
    Result<EventType> eventType = await _eventTypeRepository.get(id);
    if (eventType.isError()) return eventType;
    _eventTypesCompanion = eventType.getOrThrow().toCompanion(true);
    _log.fine("Event type loaded");
    return Success("ok");
  }

  Future<Result<void>> _update() async {
    return _eventTypeRepository.update(_eventTypesCompanion);
  }
}
