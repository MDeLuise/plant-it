import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/event_type_repository.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class EventTypeViewModel extends ChangeNotifier {
  EventTypeViewModel({
    required EventTypeRepository eventTypeRepository,
  }) : _eventTypeRepository = eventTypeRepository {
    load = Command.createAsyncNoParam(() async {
      Result<void> result = await _load();
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: null);
    delete = Command.createAsync((int id) async {
      Result<void> result = await _delete(id);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: null);
  }

  final EventTypeRepository _eventTypeRepository;
  final _log = Logger('EventTypeViewModel');

  late final Command<void, void> load;
  late final Command<int, void> delete;

  List<EventType> _eventTypes = [];

  List<EventType> get eventTypes => _eventTypes;

  Future<Result<void>> _load() async {
    final eventType = await _eventTypeRepository.getAll();
    if (eventType.isError()) {
      return eventType.exceptionOrNull()!.toFailure();
    }
    _eventTypes = eventType.getOrThrow();
    _log.fine('Loaded event types');
    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _delete(int id) async {
    return _eventTypeRepository.delete(id);
  }
}
