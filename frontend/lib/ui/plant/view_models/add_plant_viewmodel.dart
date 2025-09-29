import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/image_repository.dart';
import 'package:plant_it/data/repository/plant_repository.dart';
import 'package:plant_it/data/repository/species_care_repository.dart';
import 'package:plant_it/data/repository/species_repository.dart';
import 'package:plant_it/data/repository/species_synonym_repository.dart';
import 'package:plant_it/data/service/search/cache/app_cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class AddPlantViewModel extends ChangeNotifier {
  AddPlantViewModel({
    required PlantRepository plantRepository,
    required SpeciesRepository speciesRepository,
    required SpeciesCareRepository speciesCareRepository,
    required SpeciesSynonymsRepository speciesSynonymsRepository,
    required ImageRepository imageRepository,
    required AppCache appCache,
    Map<String, Object?>? speciesToCreate,
  })  : _plantRepository = plantRepository,
        _speciesToCreate = speciesToCreate,
        _speciesRepository = speciesRepository,
        _speciesCareRepository = speciesCareRepository,
        _speciesSynonymsRepository = speciesSynonymsRepository,
        _imageRepository = imageRepository,
        _appCache = appCache {
    load = Command.createAsync((Map<String, Object?> input) async {
      Result<void> result = await _load(input);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: null);
    insert = Command.createAsyncNoParam(() async {
      Result<int> result = await _insert();
      if (result.isError()) throw result.exceptionOrNull()!;
      return result.getOrThrow();
    }, initialValue: -1);
  }

  final PlantRepository _plantRepository;
  final Map<String, Object?>? _speciesToCreate;
  final SpeciesRepository _speciesRepository;
  final SpeciesCareRepository _speciesCareRepository;
  final SpeciesSynonymsRepository _speciesSynonymsRepository;
  final ImageRepository _imageRepository;
  final AppCache _appCache;
  final _log = Logger('AddPlantViewmodel');

  late final Command<void, int> insert;
  late final Command<Map<String, Object?>, void> load;

  late PlantsCompanion _plant;

  setName(String name) {
    _plant = _plant.copyWith(name: Value(name));
  }

  setStartDate(DateTime date) {
    _plant = _plant.copyWith(startDate: Value(date));
  }

  setNote(String note) {
    _plant = _plant.copyWith(note: Value(note));
  }

  setLocation(String location) {
    _plant = _plant.copyWith(location: Value(location));
  }

  setSeller(String seller) {
    _plant = _plant.copyWith(seller: Value(seller));
  }

  setPrice(double price) {
    _plant = _plant.copyWith(price: Value(price));
  }

  String? get name => _plant.name.value;

  Future<Result<int>> _insert() async {
    if (_speciesToCreate != null) {
      Result<int> speciesId = await _createSpecies();
      if (speciesId.isError()) {
        return speciesId;
      }
      _plant = _plant.copyWith(species: Value(speciesId.getOrThrow()));
    }

    return _plantRepository.insert(
      _plant.copyWith(
        createdAt: Value(
          DateTime.now(),
        ),
      ),
    );
  }

  Future<Result<int>> _createSpecies() async {
    SpeciesCompanion species = _speciesToCreate!['species'] as SpeciesCompanion;
    species = species.copyWith(
      id: Value.absent(),
      dataSource: Value(SpeciesDataSource.custom),
    );
    Result<int> speciesId = await _speciesRepository.insert(species.copyWith(
      externalAvatarUrl: Value.absent(),
    ));
    if (speciesId.isError()) {
      return speciesId;
    }
    _log.fine("Species saved");

    SpeciesCareCompanion care =
        _speciesToCreate['care'] as SpeciesCareCompanion;
    care = care.copyWith(species: Value(speciesId.getOrThrow()));
    Result<int> careId = await _speciesCareRepository.insert(care);
    if (careId.isError()) {
      await _speciesRepository.delete(speciesId.getOrThrow());
      return careId;
    }
    _log.fine("Species care saved");

    for (String s in _speciesToCreate['synonyms'] as List<String>) {
      SpeciesSynonymsCompanion synonyms = SpeciesSynonymsCompanion(
        species: Value(speciesId.getOrThrow()),
        synonym: Value(s),
      );
      Result<int> synonymId = await _speciesSynonymsRepository.insert(synonyms);
      if (synonymId.isError()) {
        await _speciesRepository.delete(speciesId.getOrThrow());
        await _speciesCareRepository.delete(careId.getOrThrow());
        return synonymId;
      }
    }
    _log.fine("Species synonyms saved");

    if (species.externalAvatarUrl.present) {
      Result<int> avatarResult = await _saveAvatar(
          speciesId.getOrThrow(), species.externalAvatarUrl.value!);
      if (avatarResult.isError()) {
        await _speciesRepository.delete(speciesId.getOrThrow());
        await _speciesCareRepository.delete(careId.getOrThrow());
        await _speciesSynonymsRepository
            .deleteBySpecies(speciesId.getOrThrow());
      }
    }

    await _appCache.clearSearch();

    return speciesId;
  }

  Future<Result<int>> _saveAvatar(int speciesId, String url) async {
    Result<int> imageId = await _imageRepository.insert(ImagesCompanion(
      imageUrl: Value(url),
      speciesId: Value(speciesId),
      createdAt: Value(DateTime.now()),
    ));
    if (imageId.isSuccess()) {
      _log.fine("Species URL image saved");
    }
    return imageId;
  }

  Future<Result<void>> _load(Map<String, Object?> input) async {
    int speciesId = int.parse(input['speciesId']! as String);
    String speciesName = input['speciesName']! as String;
    Result<int> count = await _plantRepository.countBySpecies(speciesId);
    if (count.isError()) {
      return count;
    }
    String plantDefaultName =
        "$speciesName${count.getOrThrow() == 0 ? "" : " ${count.getOrThrow()}"}";
    _plant = PlantsCompanion(
      species: Value(speciesId),
      name: Value(plantDefaultName),
    );
    return Success("ok");
  }
}
