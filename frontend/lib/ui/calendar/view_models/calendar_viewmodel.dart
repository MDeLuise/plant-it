import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/event_repository.dart';
import 'package:plant_it/data/repository/event_type_repository.dart';
import 'package:plant_it/data/repository/plant_repository.dart';
import 'package:plant_it/data/repository/species_repository.dart';
import 'package:plant_it/data/service/reminder_occurrence_service.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:result_dart/result_dart.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarViewModel({
    required EventRepository eventRepository,
    required PlantRepository plantRepository,
    required EventTypeRepository eventTypeRepository,
    required SpeciesRepository speciesRepository,
    required ReminderOccurrenceService reminderOccurrenceService,
  })  : _eventRepository = eventRepository,
        _plantRepository = plantRepository,
        _eventTypeRepository = eventTypeRepository,
        _speciesRepository = speciesRepository,
        _reminderOccurrenceService = reminderOccurrenceService {
    load = Command.createAsyncNoParam(() async {
      Result<void> result = await _load();
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
    loadForMonth = Command.createAsyncNoResult((DateTime month) async {
      Result<void> result = await _loadForMonth(month);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    });
    clearFilter = Command.createAsyncNoParamNoResult(() async {
      _filteredPlantIds.clear();
      _filteredEventTypeIds.clear();
      Result<void> result = await _loadForMonth(_lastLoadedMonth);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    });
    filter = Command.createAsyncNoParamNoResult(() async {
      Result<void> result = await _loadForMonth(_lastLoadedMonth);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    });
  }

  final EventRepository _eventRepository;
  final PlantRepository _plantRepository;
  final EventTypeRepository _eventTypeRepository;
  final SpeciesRepository _speciesRepository;
  final ReminderOccurrenceService _reminderOccurrenceService;
  final _log = Logger('CalendarViewModel');

  late final Command<void, void> load;
  late final Command<DateTime, void> loadForMonth;
  late final Command<void, void> filter;
  late final Command<void, void> clearFilter;

  final Map<int, List<Event>> _eventsForMonth = {};
  final Map<int, List<ReminderOccurrence>> _reminderOccurrencesForMonth = {};
  final Map<int, EventType> _eventTypes = {};
  final Map<int, Plant> _plants = {};
  final Map<int, Specy> _species = {};
  List<int> _filteredPlantIds = [];
  List<int> _filteredEventTypeIds = [];
  DateTime _lastLoadedMonth = DateTime.now();

  Map<int, List<Event>> get eventsForMonth => _eventsForMonth;
  Map<int, List<ReminderOccurrence>> get reminderOccurrencesForMonth =>
      _reminderOccurrencesForMonth;
  Map<int, EventType> get eventTypes => _eventTypes;
  Map<int, Plant> get plants => _plants;
  Map<int, Specy> get species => _species;
  List<int> get filteredPlantIds => _filteredPlantIds;
  List<Plant> get filteredPlants => _filteredPlantIds.map((id) => _plants[id]!).toList();
  List<int> get filteredEventTypeIds => _filteredEventTypeIds;
  List<EventType> get filteredEventTypes => _filteredEventTypeIds.map((id) => _eventTypes[id]!).toList();
  bool get filterActive =>
      _filteredEventTypeIds.isNotEmpty || _filteredPlantIds.isNotEmpty;

  Future<Result<void>> _load() async {
    final loadEventTypes = await _loadEventTypes();
    if (loadEventTypes.isError()) {
      return loadEventTypes.exceptionOrNull()!.toFailure();
    }
    final loadPlants = await _loadPlants();
    if (loadPlants.isError()) {
      return loadPlants.exceptionOrNull()!.toFailure();
    }
    final loadSpecies = await _loadSpecies();
    if (loadSpecies.isError()) {
      return loadSpecies.exceptionOrNull()!.toFailure();
    }
    final loadEventsForMonth = await _loadEventsForMonth(_lastLoadedMonth);
    if (loadEventsForMonth.isError()) {
      return loadEventsForMonth.exceptionOrNull()!.toFailure();
    }
    final loadOccurrencesForMonth =
        await _loadReminderOccurrencesForMonth(_lastLoadedMonth);
    if (loadOccurrencesForMonth.isError()) {
      return loadOccurrencesForMonth.exceptionOrNull()!.toFailure();
    }
    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _loadForMonth(DateTime month) async {
    _lastLoadedMonth = month;
    final loadEventsForMonth = await _loadEventsForMonth(month);
    if (loadEventsForMonth.isError()) {
      return loadEventsForMonth.exceptionOrNull()!.toFailure();
    }
    final loadOccurrencesForMonth =
        await _loadReminderOccurrencesForMonth(month);
    if (loadOccurrencesForMonth.isError()) {
      return loadOccurrencesForMonth.exceptionOrNull()!.toFailure();
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
    for (Plant p in _plants.values) {
      Result<Specy> species = await _speciesRepository.get(p.species);
      if (species.isError()) {
        _log.warning('Failed to load species', species.exceptionOrNull());
        return species.exceptionOrNull()!.toFailure();
      }
      _species.putIfAbsent(species.getOrThrow().id, () => species.getOrThrow());
    }
    _log.fine('Loaded species');
    return Success("ok");
  }

  Future<Result<void>> _loadEventsForMonth(DateTime month) async {
    List<int>? filterForPlantToUse =
        _filteredPlantIds.isEmpty ? null : _filteredPlantIds;
    List<int>? filterForEventTypeToUse =
        _filteredEventTypeIds.isEmpty ? null : _filteredEventTypeIds;
    Result<List<Event>> events = await _eventRepository.getByMonth(
        month, filterForPlantToUse, filterForEventTypeToUse);
    if (events.isError()) {
      _log.warning('Failed to load events', events.exceptionOrNull());
      return events.exceptionOrNull()!.toFailure();
    }
    _eventsForMonth.clear();
    for (Event e in events.getOrThrow()) {
      if (_eventsForMonth.containsKey(e.date.day)) {
        _eventsForMonth[e.date.day]!.add(e);
      } else {
        _eventsForMonth.putIfAbsent(e.date.day, () => [e]);
      }
    }
    _log.fine('Loaded events for month');
    return Success("ok");
  }

  Future<Result<void>> _loadReminderOccurrencesForMonth(DateTime month) async {
    List<int>? filterForPlantToUse =
        _filteredPlantIds.isEmpty ? null : _filteredPlantIds;
    List<int>? filterForEventTypeToUse =
        _filteredEventTypeIds.isEmpty ? null : _filteredEventTypeIds;
    Result<List<ReminderOccurrence>> reminderOccurrences =
        await _reminderOccurrenceService.getForMonth(
            month, filterForPlantToUse, filterForEventTypeToUse);
    if (reminderOccurrences.isError()) {
      _log.warning('Failed to load reminder occurrence',
          reminderOccurrences.exceptionOrNull());
      return reminderOccurrences.exceptionOrNull()!.toFailure();
    }
    _reminderOccurrencesForMonth.clear();
    for (ReminderOccurrence ro in reminderOccurrences.getOrThrow()) {
      if (_reminderOccurrencesForMonth.containsKey(ro.nextOccurrence.day)) {
        _reminderOccurrencesForMonth[ro.nextOccurrence.day]!.add(ro);
      } else {
        _reminderOccurrencesForMonth.putIfAbsent(
            ro.nextOccurrence.day, () => [ro]);
      }
    }
    _log.fine('Loaded reminder occurrences for month');
    return Success("ok");
  }

  void setFilteredPlants(List<Plant> plants) {
    _filteredPlantIds = plants.map((p) => p.id).toList();
    notifyListeners();
  }

  void setFilteredEventType(List<EventType> eventType) {
    _filteredEventTypeIds = eventType.map((et) => et.id).toList();
    notifyListeners();
  } 

  void updateFilter(CalendarViewModel updated) {
    _filteredEventTypeIds.clear();
    _filteredEventTypeIds.addAll(updated.filteredEventTypeIds);
    _filteredPlantIds.clear();
    _filteredPlantIds.addAll(updated.filteredPlantIds);
    //notifyListeners();
  }

  Future<Result<void>> deleteEvent(Event event) async {
    Result<void> result = await _eventRepository.delete(event.id);
    if (result.isSuccess()) {
      _eventsForMonth[event.date.day]!.removeWhere((e) => e.id == event.id);
      notifyListeners();
    }
    return Future.value(result);
  }
}
