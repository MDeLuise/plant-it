import 'dart:io';

import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:plant_it/data/repository/image_repository.dart';
import 'package:plant_it/data/repository/species_care_repository.dart';
import 'package:plant_it/data/repository/species_repository.dart';
import 'package:plant_it/data/repository/species_synonym_repository.dart';
import 'package:plant_it/data/service/search/cache/app_cache.dart';
import 'package:plant_it/database/database.dart' as db;
import 'package:result_dart/result_dart.dart';

class EditSpeciesViewModel extends ChangeNotifier {
  EditSpeciesViewModel({
    required SpeciesRepository speciesRepository,
    required SpeciesCareRepository speciesCareRepository,
    required SpeciesSynonymsRepository speciesSynonymsRepository,
    required ImageRepository imageRepository,
    required AppCache appCache,
  })  : _speciesRepository = speciesRepository,
        _speciesCareRepository = speciesCareRepository,
        _speciesSynonymsRepository = speciesSynonymsRepository,
        _imageRepository = imageRepository,
        _appCache = appCache {
    load = Command.createAsync((int id) async {
      Result<void> result = await _load(id);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: null);
    update = Command.createAsyncNoParamNoResult(() async {
      Result<void> result = await _update();
      if (result.isError()) throw result.exceptionOrNull()!;
      return result.getOrThrow();
    });
  }

  final SpeciesRepository _speciesRepository;
  final SpeciesCareRepository _speciesCareRepository;
  final SpeciesSynonymsRepository _speciesSynonymsRepository;
  final ImageRepository _imageRepository;
  final AppCache _appCache;
  final _log = Logger('EditSpeciesViewModel');

  late final Command<int, void> load;
  late final Command<void, void> update;

  db.SpeciesCompanion _species = db.SpeciesCompanion();
  db.SpeciesCareCompanion _speciesCare = db.SpeciesCareCompanion();
  List<db.SpeciesSynonymsCompanion> _speciesSynonyms = [];
  db.Image? _image;

  String get scientificName => _species.scientificName.value;
  String get species => _species.species.value;
  String? get family => _species.family.value;
  String? get genus => _species.genus.value;
  db.SpeciesDataSource get dataSource => _species.dataSource.value;
  int? get light => _speciesCare.light.value;
  int? get humidity => _speciesCare.humidity.value;
  int? get tempMax => _speciesCare.tempMax.value;
  int? get tempMin => _speciesCare.tempMin.value;
  int? get phMin => _speciesCare.phMin.value;
  int? get phMax => _speciesCare.phMax.value;
  List<String> get synonyms =>
      _speciesSynonyms.map((s) => s.synonym.value).toList();
  db.SpeciesCareCompanion get care => _speciesCare;
  db.SpeciesDataSource get source => _species.dataSource.value;
  db.Image? get image => _image;
  String? _avatarUrl;
  File? _avatarUploaded;
  bool _imageModified = false;

  void setSpecies(String species) {
    _species = _species.copyWith(
      species: Value(species),
      scientificName: Value(species),
    );
  }

  void setGenus(String genus) {
    _species = _species.copyWith(genus: Value(genus));
  }

  void setFamily(String family) {
    _species = _species.copyWith(family: Value(family));
  }

  void setLight(int light) {
    _speciesCare = _speciesCare.copyWith(light: Value(light));
  }

  void setHumidity(int humidity) {
    _speciesCare = _speciesCare.copyWith(humidity: Value(humidity));
  }

  void setTempMax(int tempMax) {
    _speciesCare = _speciesCare.copyWith(tempMax: Value(tempMax));
  }

  void setTempMin(int tempMin) {
    _speciesCare = _speciesCare.copyWith(tempMin: Value(tempMin));
  }

  void setPhMax(int phMax) {
    _speciesCare = _speciesCare.copyWith(phMax: Value(phMax));
  }

  void setPhMin(int phMin) {
    _speciesCare = _speciesCare.copyWith(phMin: Value(phMin));
  }

  void setSynonyms(List<String> synonyms) {
    _speciesSynonyms = synonyms.map((s) {
      return db.SpeciesSynonymsCompanion(
        synonym: Value(s),
        species: _species.id,
      );
    }).toList();
  }

  void setAvatarUrl(String url) {
    _imageModified = true;
    _avatarUrl = url;
  }

  void setAvatarUploaded(File file) {
    _imageModified = true;
    _avatarUploaded = file;
  }

  void setNoImage() {
    _imageModified = true;
  }

  Future<Result<void>> _load(int speciesId) async {
    Result<db.Specy> species = await _speciesRepository.get(speciesId);
    if (species.isError()) {
      return Failure(Exception(species.exceptionOrNull()));
    }
    _log.fine("Species loaded");
    _species = species.getOrThrow().toCompanion(true);

    Result<db.SpeciesCareData> care =
        await _speciesCareRepository.get(speciesId);
    if (care.isError()) {
      return Failure(Exception(care.exceptionOrNull()));
    }
    _speciesCare = care.getOrThrow().toCompanion(true);
    _log.fine("Species care loaded");

    Result<List<db.SpeciesSynonym>> synonyms =
        await _speciesSynonymsRepository.getBySpecies(speciesId);
    if (synonyms.isError()) {
      return Failure(Exception(synonyms.exceptionOrNull()));
    }
    _speciesSynonyms =
        synonyms.getOrThrow().map((s) => s.toCompanion(true)).toList();
    _log.fine("Species synonyms loaded");

    Result<db.Image>? speciesImage =
        await _imageRepository.getSpeciesImage(_species.id.value);
    if (speciesImage != null) {
      if (speciesImage.isError()) {
        return Failure(Exception(speciesImage.exceptionOrNull()));
      }
      _image = speciesImage.getOrThrow();
    }
    _log.fine("Species image loaded");

    return Success("ok");
  }

  Future<Result<bool>> _update() async {
    Result<bool> speciesId = await _speciesRepository.update(_species);
    if (speciesId.isError()) {
      return speciesId;
    }
    _log.fine("Specy updated");

    Result<bool> careId = await _speciesCareRepository.update(_speciesCare);
    if (careId.isError()) {
      return careId;
    }
    _log.fine("Specy care updated");

    await _speciesSynonymsRepository.deleteBySpecies(_species.id.value);
    for (db.SpeciesSynonymsCompanion s in _speciesSynonyms) {
      Result<int> synonymId = await _speciesSynonymsRepository.insert(
        s.copyWith(
          id: Value.absent(),
        ),
      );
      if (synonymId.isError()) {
        return Failure(Exception(synonymId.exceptionOrNull()));
      }
    }
    _log.fine("Specy synonyms updated");

    if (_imageModified) {
      Result<db.Image>? currentImage =
          await _imageRepository.getSpeciesImage(_species.id.value);
      if (currentImage != null) {
        if (currentImage.isError()) {
          return Failure(Exception(currentImage.exceptionOrNull()));
        }
        Result<void>? removed =
            await _imageRepository.removeImageForSpecies(_species.id.value);
        if (removed != null) {
          if (removed.isError()) {
            return Failure(Exception(removed.exceptionOrNull()));
          }
        }
      }
      Result<int> avatarResult = await _saveAvatar(_species.id.value);
      if (avatarResult.isError()) {
        return Failure(Exception(avatarResult.exceptionOrNull()));
      }
    }

    await _appCache.clearDetails(
        _species.id.value, db.SpeciesDataSource.custom);
    await _appCache.clearSearch();

    return speciesId;
  }

  Future<Result<int>> _saveAvatar(int speciesId) async {
    if (_avatarUploaded != null) {
      return await _handleUploadedAvatar(speciesId);
    } else if (_avatarUrl != null) {
      return await _handleUrlAvatar(speciesId);
    }
    return Success(-1);
  }

  Future<Result<int>> _handleUploadedAvatar(int speciesId) async {
    Result<String> savedPath = await _imageRepository.saveImageFile(
        _avatarUploaded!, path.extension(_avatarUploaded!.path));
    if (savedPath.isError()) {
      return Failure(Exception(savedPath.exceptionOrNull()));
    }
    Result<int> imageId = await _imageRepository.insert(db.ImagesCompanion(
      imagePath: Value(savedPath.getOrThrow()),
      speciesId: Value(speciesId),
      createdAt: Value(DateTime.now()),
    ));
    if (imageId.isError()) {
      await _imageRepository.removeImageFile(savedPath.getOrThrow());
      return imageId;
    }
    _log.fine("Specy uploaded image updated");
    return imageId;
  }

  Future<Result<int>> _handleUrlAvatar(int speciesId) async {
    Result<int> imageId = await _imageRepository.insert(db.ImagesCompanion(
      imageUrl: Value(_avatarUrl!),
      speciesId: Value(speciesId),
      createdAt: Value(DateTime.now()),
    ));
    if (imageId.isSuccess()) {
      _log.fine("Specy URL image updated");
    }
    return imageId;
  }
}
