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

class EventFormViewModel extends ChangeNotifier {
  EventFormViewModel({
    required EventRepository eventRepository,
    required PlantRepository plantRepository,
    required EventTypeRepository eventTypeRepository,
    required SpeciesRepository speciesRepository,
  })  : _eventRepository = eventRepository,
        _plantRepository = plantRepository,
        _eventTypeRepository = eventTypeRepository,
        _speciesRepository = speciesRepository {
    _date = DateTime.now();
    load = Command.createAsyncNoParam(() async {
      Result<void> result = await _load();
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
    insert = Command.createAsyncNoParam(() async {
      Result<void> result = await saveEvent();
      if (result.isError()) throw result.exceptionOrNull()!;
      return "ok";
    }, initialValue: "not started");
  }

  final EventRepository _eventRepository;
  final PlantRepository _plantRepository;
  final EventTypeRepository _eventTypeRepository;
  final SpeciesRepository _speciesRepository;
  final _log = Logger('EventFormViewModel');

  late final Command<void, void> load;
  late final Command<void, String> insert;

  List<Plant> _plants = [];
  List<EventType> _eventTypes = [];
  List<Plant> _selectedPlants = [];
  List<EventType> _selectedEventTypes = [];
  Map<int, Specy> _species = {};
  String? _note;
  DateTime? _date;
  bool _isSubmitting = false;
  String? errorMessage;

  List<Plant> get plants => _plants;
  List<EventType> get eventTypes => _eventTypes;
  bool get isSubmitting => _isSubmitting;
  List<EventType> get selectedEventTypes => _selectedEventTypes;
  List<Plant> get selectedPlants => _selectedPlants;
  String? get note => _note;
  DateTime? get date => _date;

  Future<Result<void>> _load() async {
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

  Future<Result<void>> _loadPlants() async {
    Result<List<Plant>> plants = await _plantRepository.getAll();
    if (plants.isError()) {
      _log.warning('Failed to load plants', plants.exceptionOrNull());
      return plants.exceptionOrNull()!.toFailure();
    }
    _plants = plants.getOrThrow();
    _log.fine('Loaded plants');
    return Success("ok");
  }

  Future<Result<void>> _loadEventTypes() async {
    Result<List<EventType>> eventTypes = await _eventTypeRepository.getAll();
    if (eventTypes.isError()) {
      _log.warning('Failed to load event types', eventTypes.exceptionOrNull());
      return eventTypes.exceptionOrNull()!.toFailure();
    }
    _eventTypes = eventTypes.getOrThrow();
    _log.fine('Loaded event types');
    return Success("ok");
  }

  Future<Result<void>> _loadSpecies() async {
    for (Plant plant in _plants) {
      Result<Specy> species = await _speciesRepository.get(plant.species);
      if (species.isError()) {
        _log.warning('Failed to load species', species.exceptionOrNull());
        return species.exceptionOrNull()!.toFailure();
      }
      _species.putIfAbsent(plant.id, () => species.getOrThrow());
    }
    return Success("ok");
  }

  void setPlantList(List<Plant> plants) {
    _selectedPlants = plants;
    notifyListeners();
  }

  void addPlant(Plant plant) {
    _selectedPlants.add(plant);
    notifyListeners();
  }

  void removePlant(Plant plant) {
    _selectedPlants.remove(plant);
    notifyListeners();
  }

  bool isPlantSelected(Plant plant) {
    return _selectedPlants.contains(plant);
  }

  Specy getSpecies(int plantId) {
    return _species[plantId]!;
  }

  void setEventTypeList(List<EventType> eventTypes) {
    _selectedEventTypes = eventTypes;
    notifyListeners();
  }

  void addEventType(EventType eventType) {
    _selectedEventTypes.add(eventType);
    notifyListeners();
  }

  void removeEventType(EventType eventType) {
    _selectedEventTypes.remove(eventType);
    notifyListeners();
  }

  bool isEventTypeSelected(EventType eventType) {
    return _selectedEventTypes.contains(eventType);
  }

  void setNote(String newNote) {
    _note = newNote;
    notifyListeners();
  }

  void setDate(DateTime newDate) {
    _date = newDate;
    notifyListeners();
  }

  Future<Result<void>> saveEvent() async {
    if (_selectedPlants.isEmpty ||
        _selectedEventTypes.isEmpty ||
        _date == null) {
      return Failure(Exception("Missing required fields"));
    }

    _isSubmitting = true;
    notifyListeners();

    try {
      for (final plant in _selectedPlants) {
        for (final type in _selectedEventTypes) {
          final companion = EventsCompanion.insert(
            type: type.id,
            plant: plant.id,
            date: _date!,
            note: Value(_note),
          );
          await _eventRepository.insert(companion);
        }
      }
      return const Success("ok");
    } catch (e) {
      errorMessage = e.toString();
      return Failure(Exception(errorMessage));
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
