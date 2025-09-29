import 'dart:async';
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
import 'package:plant_it/database/database.dart';
import 'package:plant_it/utils/stream_code.dart';
import 'package:result_dart/result_dart.dart';

class AddSpeciesViewModel extends ChangeNotifier {
  AddSpeciesViewModel({
    required SpeciesRepository speciesRepository,
    required SpeciesCareRepository speciesCareRepository,
    required SpeciesSynonymsRepository speciesSynonymsRepository,
    required ImageRepository imageRepository,
    required AppCache appCache,
    required StreamController<StreamCode> streamController,
  })  : _speciesRepository = speciesRepository,
        _speciesCareRepository = speciesCareRepository,
        _speciesSynonymsRepository = speciesSynonymsRepository,
        _imageRepository = imageRepository,
        _streamController = streamController,
        _appCache = appCache {
    insert = Command.createAsyncNoParam(() async {
      Result<int> result = await _save();
      if (result.isError()) throw result.exceptionOrNull()!;
      return result.getOrThrow();
    }, initialValue: -1);
  }

  final SpeciesRepository _speciesRepository;
  final SpeciesCareRepository _speciesCareRepository;
  final SpeciesSynonymsRepository _speciesSynonymsRepository;
  final ImageRepository _imageRepository;
  final StreamController<StreamCode> _streamController;
  final AppCache _appCache;
  final _log = Logger('AddSpeciesViewModel');

  late final Command<void, int> insert;

  SpeciesCompanion _speciesCompanion = SpeciesCompanion(
    dataSource: Value(SpeciesDataSource.custom),
  );
  SpeciesCareCompanion _speciesCareCompanion = SpeciesCareCompanion();
  List<SpeciesSynonymsCompanion> _speciesSynonymsCompanion = [];
  String? _avatarUrl;
  File? _avatarUploaded;

  void setSpecies(String species) {
    _speciesCompanion = _speciesCompanion.copyWith(
      species: Value(species),
      scientificName: Value(species),
    );
  }

  void setGenus(String genus) {
    _speciesCompanion = _speciesCompanion.copyWith(genus: Value(genus));
  }

  void setFamily(String family) {
    _speciesCompanion = _speciesCompanion.copyWith(family: Value(family));
  }

  void setLight(int light) {
    _speciesCareCompanion = _speciesCareCompanion.copyWith(light: Value(light));
  }

  void setHumidity(int humidity) {
    _speciesCareCompanion = _speciesCareCompanion.copyWith(humidity: Value(humidity));
  }

  void setTempMax(int tempMax) {
    _speciesCareCompanion = _speciesCareCompanion.copyWith(tempMax: Value(tempMax));
  }

  void setTempMin(int tempMin) {
    _speciesCareCompanion = _speciesCareCompanion.copyWith(tempMin: Value(tempMin));
  }

  void setPhMax(int phMax) {
    _speciesCareCompanion = _speciesCareCompanion.copyWith(phMax: Value(phMax));
  }

  void setPhMin(int phMin) {
    _speciesCareCompanion = _speciesCareCompanion.copyWith(phMin: Value(phMin));
  }

  void setSynonyms(List<String> synonyms) {
    for (String s in synonyms) {
      _speciesSynonymsCompanion
          .add(SpeciesSynonymsCompanion(synonym: Value(s)));
    }
  }

  void _setSpeciesId(int id) {
    _speciesCareCompanion = _speciesCareCompanion.copyWith(species: Value(id));
    _speciesSynonymsCompanion = _speciesSynonymsCompanion.map((s) {
      return s.copyWith(species: Value(id));
    }).toList();
  }

  void setAvatarUrl(String url) {
    _avatarUrl = url;
  }

  void setAvatarUploaded(File file) {
    _avatarUploaded = file;
  }

  Future<Result<int>> _save() async {
    Result<int> speciesId = await _speciesRepository.insert(_speciesCompanion);
    if (speciesId.isError()) {
      return speciesId;
    }
    _log.fine("Species saved");
    _setSpeciesId(speciesId.getOrThrow());
    Result<int> careId =
        await _speciesCareRepository.insert(_speciesCareCompanion);
    if (careId.isError()) {
      await _speciesRepository.delete(speciesId.getOrThrow());
      return careId;
    }
    _log.fine("Species care saved");
    for (SpeciesSynonymsCompanion s in _speciesSynonymsCompanion) {
      Result<int> synonymId = await _speciesSynonymsRepository.insert(s);
      if (synonymId.isError()) {
        await _speciesRepository.delete(speciesId.getOrThrow());
        await _speciesCareRepository.delete(careId.getOrThrow());
        return synonymId;
      }
    }
    _log.fine("Species synonyms saved");

    Result<int> avatarResult = await _saveAvatar(speciesId.getOrThrow());
    if (avatarResult.isError()) {
      await _speciesRepository.delete(speciesId.getOrThrow());
      await _speciesCareRepository.delete(careId.getOrThrow());
      await _speciesSynonymsRepository.deleteBySpecies(speciesId.getOrThrow());
    }

    await _appCache.clearSearch();
    _streamController.add(StreamCode.insertSpecies);

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
    Result<int> imageId = await _imageRepository.insert(ImagesCompanion(
      imagePath: Value(savedPath.getOrThrow()),
      speciesId: Value(speciesId),
      createdAt: Value(DateTime.now()),
    ));
    if (imageId.isError()) {
      await _imageRepository.removeImageFile(savedPath.getOrThrow());
      return imageId;
    }
    _log.fine("Species uploaded image saved");
    return imageId;
  }

  Future<Result<int>> _handleUrlAvatar(int speciesId) async {
    Result<int> imageId = await _imageRepository.insert(ImagesCompanion(
      imageUrl: Value(_avatarUrl!),
      speciesId: Value(speciesId),
      createdAt: Value(DateTime.now()),
    ));
    if (imageId.isSuccess()) {
      _log.fine("Species URL image saved");
    }
    return imageId;
  }
}
