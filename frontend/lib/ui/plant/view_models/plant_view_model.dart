import 'dart:convert';
import 'dart:io';

import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:plant_it/data/repository/event_repository.dart';
import 'package:plant_it/data/repository/event_type_repository.dart';
import 'package:plant_it/data/repository/image_repository.dart';
import 'package:plant_it/data/repository/plant_repository.dart';
import 'package:plant_it/data/repository/reminder_occurrence_repository.dart';
import 'package:plant_it/data/repository/reminder_repository.dart';
import 'package:plant_it/data/repository/species_care_repository.dart';
import 'package:plant_it/data/repository/species_repository.dart';
import 'package:plant_it/database/database.dart' as db;
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:result_dart/result_dart.dart';

class PlantViewModel extends ChangeNotifier {
  PlantViewModel({
    required PlantRepository plantRepository,
    required SpeciesRepository speciesRepository,
    required SpeciesCareRepository speciesCareRepository,
    required ImageRepository imageRepository,
    required EventRepository eventRepository,
    required EventTypeRepository eventTypeRepository,
    required ReminderRepository reminderRepository,
    required ReminderOccurrenceRepository reminderOccurrenceRepository,
  })  : _plantRepository = plantRepository,
        _speciesRepository = speciesRepository,
        _speciesCareRepository = speciesCareRepository,
        _imageRepository = imageRepository,
        _eventRepository = eventRepository,
        _eventTypeRepository = eventTypeRepository,
        _reminderRepository = reminderRepository,
        _reminderOccurrenceRepository = reminderOccurrenceRepository {
    deletePlant = Command.createAsyncNoParam(_deletePlant,
        initialValue: Failure(Exception("not started")));
    duplicatePlant = Command.createAsyncNoParamNoResult(() async {
      Result<int> result = await _duplicatePlant();
      if (result.isError()) throw result.exceptionOrNull()!;
      load.executeWithFuture(result.getOrThrow());
    });
    uploadNewPhoto = Command.createAsyncNoResult((XFile file) async {
      Result<int> result = await _uploadNewPhoto(file);
      if (result.isError()) throw result.exceptionOrNull()!;
      load.executeWithFuture(_plant.id);
    });
    load = Command.createAsyncNoResult((int plantId) async {
      Result<void> result = await _load(plantId);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    });
    deletePhoto = Command.createAsync((int id) async {
      Result<void> result = await _deletePhoto(id);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
    toggleAvatar = Command.createAsync((int? id) async {
      Result<void> result = await _toggleAvatar(id);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
    downloadPhoto = Command.createAsync((int id) async {
      Result<void> result = await _downloadPhoto(id);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
  }

  final Logger _log = Logger('PlantViewModel');
  final PlantRepository _plantRepository;
  final SpeciesRepository _speciesRepository;
  final SpeciesCareRepository _speciesCareRepository;
  final ImageRepository _imageRepository;
  final EventRepository _eventRepository;
  final EventTypeRepository _eventTypeRepository;
  final ReminderRepository _reminderRepository;
  final ReminderOccurrenceRepository _reminderOccurrenceRepository;
  String? _base64Avatar;
  late List<db.Image> _galleryImage;
  late db.Specy _species;
  late db.SpeciesCareData _care;
  late db.Plant _plant;
  late List<db.EventType> _eventType;
  late List<db.Event> _events;
  late List<db.Reminder> _reminders;
  late List<ReminderOccurrence> _remindersOccurrences;
  late List<String> _thumbnails;

  String? get base64Avatar => _base64Avatar;
  List<db.Image> get galleryImage => _galleryImage;
  db.Specy get species => _species;
  db.SpeciesCareData get care => _care;
  db.Plant get plant => _plant;
  List<db.EventType> get eventType => _eventType;
  List<db.Event> get events => _events;
  List<db.Reminder> get reminders => _reminders;
  List<ReminderOccurrence> get remindersOccurrences => _remindersOccurrences;
  List<String> get thumbnails => _thumbnails;
  int get id => _plant.id;

  late final Command<int, void> load;
  late final Command<void, Result<void>> deletePlant;
  late final Command<void, void> duplicatePlant;
  late final Command<XFile, void> uploadNewPhoto;
  late final Command<int, void> deletePhoto;
  late final Command<int?, void> toggleAvatar;
  late final Command<int, void> downloadPhoto;

  EventRepository get eventRepository => _eventRepository;

  ReminderRepository get reminderRepository => _reminderRepository;

  Future<Result<void>> _load(int plantId) async {
    final loadPlant = await _loadPlant(plantId);
    if (loadPlant.isError()) {
      return loadPlant.exceptionOrNull()!.toFailure();
    }
    final loadBase64Result = await _loadBase64(plantId);
    if (loadBase64Result.isError()) {
      return loadBase64Result.exceptionOrNull()!.toFailure();
    }
    final loadGalleryImagesResult = await _loadGalleryImages(plantId);
    if (loadGalleryImagesResult.isError()) {
      return loadGalleryImagesResult.exceptionOrNull()!.toFailure();
    }
    final loadSpeciesResult = await _loadSpecies(plantId);
    if (loadSpeciesResult.isError()) {
      return loadSpeciesResult.exceptionOrNull()!.toFailure();
    }
    final loadCareResult = await _loadCare(plantId);
    if (loadCareResult.isError()) {
      return loadCareResult.exceptionOrNull()!.toFailure();
    }
    final loadEventTypeResult = await _loadEventType();
    if (loadEventTypeResult.isError()) {
      return loadEventTypeResult.exceptionOrNull()!.toFailure();
    }
    final loadLastEventResult = await _loadLastEvent(plantId);
    if (loadLastEventResult.isError()) {
      return loadLastEventResult.exceptionOrNull()!.toFailure();
    }
    final loadRemindersResult = await _loadReminders(plantId);
    if (loadRemindersResult.isError()) {
      return loadRemindersResult.exceptionOrNull()!.toFailure();
    }
    final loadRemindersOccurrencesResult =
        await _loadNextOccurrenceOfAllReminder();
    if (loadRemindersOccurrencesResult.isError()) {
      return loadRemindersOccurrencesResult.exceptionOrNull()!.toFailure();
    }
    final loadThumbnails = await _loadThumbnails();
    if (loadThumbnails.isError()) {
      return loadThumbnails.exceptionOrNull()!.toFailure();
    }
    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _loadBase64(int plantId) async {
    Result<db.Image>? avatarResult =
        await _imageRepository.getSpecifiedAvatarForPlant(plantId);
    if (avatarResult != null && avatarResult.isError()) {
      return avatarResult.exceptionOrNull()!.toFailure();
    }
    if (avatarResult != null && avatarResult.isSuccess()) {
      Result<String> base64 =
          await _imageRepository.getBase64(avatarResult.getOrThrow().id);
      if (base64.isError()) {
        return base64.exceptionOrNull()!.toFailure();
      }
      _base64Avatar = base64.getOrThrow();
      return Success("ok");
    }

    Result<db.Image>? speciesImage =
        await _imageRepository.getSpeciesImage(_plant.species);
    if (speciesImage != null && speciesImage.isError()) {
      return speciesImage.exceptionOrNull()!.toFailure();
    }
    if (speciesImage != null && speciesImage.isSuccess()) {
      Result<String> base64 =
          await _imageRepository.getBase64(speciesImage.getOrThrow().id);
      if (base64.isError()) {
        return base64.exceptionOrNull()!.toFailure();
      }
      _base64Avatar = base64.getOrThrow();
      return Success("ok");
    }
    return Success("no avatar");
  }

  Future<Result<void>> _loadGalleryImages(int plantId) async {
    Result<List<db.Image>> images =
        await _imageRepository.getImagesForPlant(plantId);
    if (images.isError()) {
      return images.exceptionOrNull()!.toFailure();
    }
    _galleryImage = images.getOrThrow();
    return Success("ok");
  }

  Future<Result<void>> _loadSpecies(int plantId) async {
    Result<db.Plant> plant = await _plantRepository.get(plantId);
    if (plant.isError()) {
      return plant.exceptionOrNull()!.toFailure();
    }
    Result<db.Specy> species =
        await _speciesRepository.get(plant.getOrThrow().species);
    if (species.isError()) {
      return species.exceptionOrNull()!.toFailure();
    }
    _species = species.getOrThrow();
    return Success("ok");
  }

  Future<Result<void>> _loadCare(int plantId) async {
    Result<db.Plant> plant = await _plantRepository.get(plantId);
    if (plant.isError()) {
      return plant.exceptionOrNull()!.toFailure();
    }
    Result<db.SpeciesCareData> care =
        await _speciesCareRepository.get(plant.getOrThrow().species);
    if (care.isError()) {
      return care.exceptionOrNull()!.toFailure();
    }
    _care = care.getOrThrow();
    return Success("ok");
  }

  Future<Result<void>> _deletePlant() {
    return _plantRepository.delete(_plant.id);
  }

  Future<Result<int>> _duplicatePlant() async {
    try {
      Result<db.Plant> plant = await _plantRepository.get(_plant.id);
      if (plant.isError()) {
        return plant.exceptionOrNull()!.toFailure();
      }
      String duplicateName = "${plant.getOrThrow().name} copy";
      Result<int> duplicatedId = await _plantRepository
          .insert(plant.getOrThrow().toCompanion(true).copyWith(
                name: drift.Value(duplicateName),
                id: const drift.Value.absent(),
              ));
      if (duplicatedId.isError()) {
        return duplicatedId.exceptionOrNull()!.toFailure();
      }
      return duplicatedId;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<int>> _uploadNewPhoto(XFile pickedFile) async {
    try {
      File file = File(pickedFile.path);
      String extension = path.extension(file.path);

      Result<String> savedPath =
          await _imageRepository.saveImageFile(file, extension);
      if (savedPath.isError()) {
        return savedPath.exceptionOrNull()!.toFailure();
      }
      db.ImagesCompanion newImage = db.ImagesCompanion(
        imagePath: drift.Value(savedPath.getOrThrow()),
        plantId: drift.Value(_plant.id),
        createdAt: drift.Value(DateTime.now()),
      );
      return _imageRepository.insert(newImage);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _loadPlant(int plantId) async {
    Result<db.Plant> plant = await _plantRepository.get(plantId);
    if (plant.isError()) {
      notifyListeners();
      return plant.exceptionOrNull()!.toFailure();
    }
    _plant = plant.getOrThrow();
    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _loadEventType() async {
    Result<List<db.EventType>> eventType = await _eventTypeRepository.getAll();
    if (eventType.isError()) {
      notifyListeners();
      return eventType.exceptionOrNull()!.toFailure();
    }
    _eventType = eventType.getOrThrow();
    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _loadLastEvent(int plantId) async {
    Result<List<db.Event>> event =
        await _eventRepository.getLastEventsForPlant(plantId);
    if (event.isError()) {
      notifyListeners();
      return event.exceptionOrNull()!.toFailure();
    }
    _events = event.getOrThrow();
    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _loadReminders(int plantId) async {
    Result<List<db.Reminder>> reminders =
        await _reminderRepository.getFiltered([plantId], null);
    if (reminders.isError()) {
      notifyListeners();
      return reminders.exceptionOrNull()!.toFailure();
    }
    _reminders = reminders.getOrThrow();
    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _loadNextOccurrenceOfAllReminder() async {
    List<ReminderOccurrence> result = [];
    for (db.Reminder r in _reminders) {
      Result<List<ReminderOccurrence>> nextOccurrence =
          await _reminderOccurrenceRepository.getNextOccurrencesOfReminder(
              r, 1);
      if (nextOccurrence.isError()) {
        return nextOccurrence.exceptionOrNull()!.toFailure();
      }
      result.addAll(nextOccurrence.getOrThrow());
    }
    _remindersOccurrences = result;
    return Success("ok");
  }

  Future<Result<void>> _loadThumbnails() async {
    int maxThumbnailsToLoad = 5;
    List<String> thumbnails = [];

    try {
      Iterable<db.Image> imagesToLoad = _galleryImage.take(maxThumbnailsToLoad);

      for (db.Image image in imagesToLoad) {
        Result<String> base64Result =
            await _imageRepository.getBase64(image.id);

        if (base64Result.isError()) {
          return Failure(base64Result.exceptionOrNull()!);
        }

        thumbnails.add(base64Result.getOrThrow());
      }

      _thumbnails = thumbnails;
      return const Success("ok");
    } catch (e) {
      return Failure(Exception('Failed to load thumbnails: $e'));
    }
  }

  Future<Result<String>> getBase64(int id) {
    return _imageRepository.getBase64(id);
  }

  Future<Result<void>> _deletePhoto(int id) async {
    Result<void> deleted = await _imageRepository.delete(id);

    await _loadGalleryImages(_plant.id);
    await _loadThumbnails();

    return deleted;
  }

  Future<Result<void>> _toggleAvatar(int? id) async {
    Result<db.Image>? currentAvatar =
        await _imageRepository.getSpecifiedAvatarForPlant(_plant.id);

    if (id == null) {
      Result<void> unset =
          await _imageRepository.unsetAvatarForPlant(_plant.id);
      if (unset.isError()) {
        return unset;
      }
      Result<void> gallery = await _loadGalleryImages(_plant.id);
      if (gallery.isError()) {
        return gallery;
      }
      return _loadBase64(_plant.id);
    }

    Result<db.Image> image = await _imageRepository.get(id);
    if (image.isError()) {
      return image;
    }

    if (currentAvatar != null && currentAvatar.isError()) {
      return currentAvatar;
    }
    if (currentAvatar == null || currentAvatar.getOrThrow().id != id) {
      if (currentAvatar != null) {
        Result<void> unset =
            await _imageRepository.unsetAvatarForPlant(_plant.id);
        if (unset.isError()) {
          return unset;
        }
      }

      Result<void> updated = await _imageRepository.update(
          image.getOrThrow().copyWith(isAvatar: true).toCompanion(true));
      if (updated.isError()) {
        return updated;
      }
    }
    Result<void> gallery = await _loadGalleryImages(_plant.id);
    if (gallery.isError()) {
      return gallery;
    }
    return _loadBase64(_plant.id);
  }

  Future<Result<void>> _downloadPhoto(int id) async {
    Result<String> base64Result = await _imageRepository.getBase64(id);
    if (base64Result.isError()) {
      return base64Result.exceptionOrNull()!.toFailure();
    }

    drift.Uint8List imageBytes = base64Decode(base64Result.getOrThrow());
    final directory = await getExternalStorageDirectory();
    final filePath = path.join(directory!.path, 'image_$id.jpg');
    final File file = File(filePath);
    await file.writeAsBytes(imageBytes);

    return Success("Image downloaded successfully to $filePath");
  }
}
