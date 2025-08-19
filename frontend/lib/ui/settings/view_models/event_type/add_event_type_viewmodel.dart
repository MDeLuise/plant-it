import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/event_type_repository.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class AddEventTypeViewModel extends ChangeNotifier {
  AddEventTypeViewModel({
    required EventTypeRepository eventTypeRepository,
  }) : _eventTypeRepository = eventTypeRepository {
    insert = Command.createAsyncNoParam(() async {
      Result<void> result = await _insert();
      if (result.isError()) throw result.exceptionOrNull()!;
    }, initialValue: Failure(Exception("not started")));
  }

  final EventTypeRepository _eventTypeRepository;
  final _log = Logger('AddEventTypeViewModel');
  EventTypesCompanion _eventTypesCompanion = EventTypesCompanion();

  late final Command<void, void> insert;

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

  Future<Result<void>> _insert() async {
    return _eventTypeRepository.insert(_eventTypesCompanion);
  }
}
