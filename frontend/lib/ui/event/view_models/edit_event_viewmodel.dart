import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/event_repository.dart';
import 'package:plant_it/data/repository/event_type_repository.dart';
import 'package:plant_it/data/repository/plant_repository.dart';
import 'package:plant_it/data/repository/species_repository.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class EditEventFormViewModel extends ChangeNotifier {
  EditEventFormViewModel({
    required EventRepository eventRepository,
    required PlantRepository plantRepository,
    required EventTypeRepository eventTypeRepository,
    required SpeciesRepository speciesRepository,
  })  : _eventRepository = eventRepository,
        _plantRepository = plantRepository,
        _eventTypeRepository = eventTypeRepository,
        _speciesRepository = speciesRepository {
    load = Command.createAsync((int eventId) async {
      Result<void> result = await _load(eventId);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
    update = Command.createAsyncNoParam(() async {
      Result<void> result = await updateEvent();
      if (result.isError()) throw result.exceptionOrNull()!;
      return "ok";
    }, initialValue: "not started");
  }

  final EventRepository _eventRepository;
  final PlantRepository _plantRepository;
  final EventTypeRepository _eventTypeRepository;
  final SpeciesRepository _speciesRepository;
  final _log = Logger('EditEventFormViewModel');

  late final Command<int, void> load;
  late final Command<void, String> update;

  final Map<int, Plant> _plants = {};
  final Map<int, EventType> _eventTypes = {};
  final Map<int, Specy> _species = {};
  EventsCompanion _eventCompanion = EventsCompanion();
  bool _isSubmitting = false;
  String? errorMessage;

  Map<int, Plant> get plants => _plants;
  Map<int, EventType> get eventTypes => _eventTypes;
  Map<int, Specy> get species => _species;
  bool get isSubmitting => _isSubmitting;
  EventType get eventType => _eventTypes[_eventCompanion.type.value]!;
  Plant get plant => _plants[_eventCompanion.plant.value]!;
  String? get note => _eventCompanion.note.value;
  DateTime get date => _eventCompanion.date.value;

  Future<Result<void>> _load(int eventId) async {
    final loadEvent = await _loadEvent(eventId);
    if (loadEvent.isError()) {
      return loadEvent.exceptionOrNull()!.toFailure();
    }
    final loadPlants = await _loadPlants();
    if (loadPlants.isError()) {
      return loadPlants.exceptionOrNull()!.toFailure();
    }
    final loadEventTypes = await _loadEventTypes();
    if (loadEventTypes.isError()) {
      return loadEventTypes.exceptionOrNull()!.toFailure();
    }
    final loadSpecies = await _loadSpecies();
    if (loadSpecies.isError()) {
      return loadSpecies.exceptionOrNull()!.toFailure();
    }
    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _loadEvent(int eventId) async {
    final event = await _eventRepository.get(eventId);
    if (event.isError()) {
      return event.exceptionOrNull()!.toFailure();
    }
    _eventCompanion = event.getOrThrow().toCompanion(true);
    _log.fine('Loaded event');
    return Success("ok");
  }

  Future<Result<void>> _loadPlants() async {
    Result<List<Plant>> plants = await _plantRepository.getAll();
    if (plants.isError()) {
      _log.warning('Failed to load plants', plants.exceptionOrNull());
      return plants.exceptionOrNull()!.toFailure();
    }
    for (Plant p in plants.getOrThrow()) {
      _plants.putIfAbsent(p.id, () => p);
    }
    _log.fine('Loaded plants');
    return Success("ok");
  }

  Future<Result<void>> _loadEventTypes() async {
    Result<List<EventType>> eventTypes = await _eventTypeRepository.getAll();
    if (eventTypes.isError()) {
      _log.warning('Failed to load event types', eventTypes.exceptionOrNull());
      return eventTypes.exceptionOrNull()!.toFailure();
    }
    for (EventType et in eventTypes.getOrThrow()) {
      _eventTypes.putIfAbsent(et.id, () => et);
    }
    _log.fine('Loaded event types');
    return Success("ok");
  }

  Future<Result<void>> _loadSpecies() async {
    for (Plant plant in _plants.values) {
      Result<Specy> species = await _speciesRepository.get(plant.species);
      if (species.isError()) {
        _log.warning('Failed to load species', species.exceptionOrNull());
        return species.exceptionOrNull()!.toFailure();
      }
      _species.putIfAbsent(plant.id, () => species.getOrThrow());
    }
    return Success("ok");
  }

  void setPlant(Plant plant) {
    _eventCompanion = _eventCompanion.copyWith(plant: Value(plant.id));
    notifyListeners();
  }

  Specy getSpecies(int plantId) {
    return _species[plantId]!;
  }

  void setEventType(EventType eventType) {
    _eventCompanion = _eventCompanion.copyWith(type: Value(eventType.id));
    notifyListeners();
  }

  void setDate(DateTime date) {
    _eventCompanion = _eventCompanion.copyWith(date: Value(date));
    notifyListeners();
  }

  void setNote(String note) {
    _eventCompanion = _eventCompanion.copyWith(note: Value(note));
    notifyListeners();
  }

  Future<Result<void>> updateEvent() async {
    _isSubmitting = true;
    notifyListeners();

    Result<void> result = await _eventRepository.update(_eventCompanion);
    if (result.isError()) {
      return result.exceptionOrNull()!.toFailure();
    }
    notifyListeners();
    return const Success("ok");
  }
}
