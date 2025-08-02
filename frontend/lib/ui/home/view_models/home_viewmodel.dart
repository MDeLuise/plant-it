import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/image_repository.dart';
import 'package:plant_it/data/repository/plant_repository.dart';
import 'package:plant_it/data/repository/reminder_occurrence_repository.dart';
import 'package:plant_it/database/database.dart' as db;
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required PlantRepository plantRepository,
    required ReminderOccurrenceRepository reminderOccurrenceRepository,
    required ImageRepository imageRepository,
  })  : _plantRepository = plantRepository,
        _reminderOccurrenceRepository = reminderOccurrenceRepository,
        _imageRepository = imageRepository {
    load = Command.createAsyncNoParam(() async {
      Result<void> result = await _load();
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
  }

  final PlantRepository _plantRepository;
  final ReminderOccurrenceRepository _reminderOccurrenceRepository;
  final ImageRepository _imageRepository;
  final _log = Logger('HomeViewModel');
  List<db.Plant> _plants = [];
  final Map<int, db.Plant> _plantMap = {};
  final Map<int, String?> _imagesBase64 = {};
  List<ReminderOccurrence> _reminderOccurences = [];

  late final Command<void, void> load;

  List<db.Plant> get plants => _plants;
  Map<int, db.Plant> get plantMap => _plantMap;
  Map<int, String?> get imagesBase64 => _imagesBase64;
  List<ReminderOccurrence> get reminderOccurrences => _reminderOccurences;

  Future<Result<void>> _load() async {
    final loadPlants = await _loadPlants();
    if (loadPlants.isError()) {
      return loadPlants.exceptionOrNull()!.toFailure();
    }
    final loadAvatarBase64 = await _loadAvatarBase64();
    if (loadAvatarBase64.isError()) {
      return loadAvatarBase64.exceptionOrNull()!.toFailure();
    }
    final loadReminderOccurrences = await _loadReminderOccurrences();
    if (loadReminderOccurrences.isError()) {
      return loadReminderOccurrences.exceptionOrNull()!.toFailure();
    }
    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _loadPlants() async {
    Result<List<db.Plant>> plants = await _plantRepository.getAll();
    if (plants.isError()) {
      _log.warning('Failed to load plants', plants.exceptionOrNull());
      return plants.exceptionOrNull()!.toFailure();
    }
    _plants = plants.getOrThrow();
    for (db.Plant p in _plants) {
      _plantMap.putIfAbsent(p.id, () => p);
    }
    _log.fine('Loaded plants');
    return Success("ok");
  }

  Future<Result<void>> _loadAvatarBase64() async {
    for (db.Plant p in _plants) {
      Result<String>? base64 =
          await _imageRepository.getSpecifiedAvatarForPlantBase64(p.id);
      if (base64 != null) {
        _imagesBase64.putIfAbsent(p.id, () => base64.getOrThrow());
      }
    }
    _log.fine('Loaded base64 plants avatar');
    return Success("ok");
  }

  Future<Result<void>> _loadReminderOccurrences() async {
    Result<List<ReminderOccurrence>> nextOccurrences =
        await _reminderOccurrenceRepository.getNextOccurrences(5);
    if (nextOccurrences.isError()) {
      return nextOccurrences.exceptionOrNull()!.toFailure();
    }
    _reminderOccurences = nextOccurrences.getOrThrow();
    return Success("ok");
  }
}
