import 'dart:convert';
import 'dart:io';

import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;
import 'package:plant_it/data/repository/image_repository.dart';
import 'package:plant_it/data/repository/species_care_repository.dart';
import 'package:plant_it/data/repository/species_repository.dart';
import 'package:plant_it/data/repository/species_synonym_repository.dart';
import 'package:plant_it/data/service/search/cache/app_cache.dart';
import 'package:plant_it/data/service/search/species_searcher_facade.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:result_dart/result_dart.dart';

class ViewSpeciesViewModel extends ChangeNotifier {
  ViewSpeciesViewModel({
    required SpeciesRepository speciesRepository,
    required SpeciesCareRepository speciesCareRepository,
    required SpeciesSynonymsRepository speciesSynonymsRepository,
    required ImageRepository imageRepository,
    required AppCache appCache,
    required SpeciesSearcherFacade speciesSearcherFacade,
  })  : _speciesRepository = speciesRepository,
        _speciesCareRepository = speciesCareRepository,
        _speciesSynonymsRepository = speciesSynonymsRepository,
        _imageRepository = imageRepository,
        _appCache = appCache,
        _speciesSearcherFacade = speciesSearcherFacade {
    load = Command.createAsyncNoResult((dynamic idOrExternal) async {
      if (idOrExternal is int) {
        Result<void> result = await _load(idOrExternal);
        if (result.isError()) throw result.exceptionOrNull()!;
        return result.getOrThrow();
      } else if (idOrExternal is SpeciesSearcherPartialResult) {
        Result<void> result = await _loadExternal(idOrExternal);
        if (result.isError()) throw result.exceptionOrNull()!;
        _isExternal = true;
        return result.getOrThrow();
      }
      throw Exception(
          "idOrExternal must be an int or an SpeciesSearcherResult");
    });
    duplicate = Command.createAsyncNoParamNoResult(() async {
      Result<int> result = await _duplicate();
      if (result.isError()) throw result.exceptionOrNull()!;
      return load.execute(result.getOrThrow());
    });
    delete = Command.createAsyncNoParam(() async {
      Result<void> result = await _delete();
      if (result.isError()) throw result.exceptionOrNull()!;
      return result.getOrThrow();
    }, initialValue: null);
  }

  final SpeciesRepository _speciesRepository;
  final SpeciesCareRepository _speciesCareRepository;
  final SpeciesSynonymsRepository _speciesSynonymsRepository;
  final ImageRepository _imageRepository;
  final AppCache _appCache;
  final SpeciesSearcherFacade _speciesSearcherFacade;
  final _log = Logger('ViewSpeciesViewModel');

  late final Command<dynamic, void> load;
  late final Command<SpeciesSearcherResult, void> loadExternal;
  late final Command<void, void> duplicate;
  late final Command<void, void> delete;

  late SpeciesCompanion _species;
  late SpeciesCareCompanion _speciesCare;
  late List<SpeciesSynonymsCompanion> _speciesSynonyms = [];
  String? _base64Image;
  bool _isExternal = false;

  int? get id => _species.id.value;
  String get scientificName => _species.scientificName.value;
  String get species => _species.species.value;
  String? get family => _species.family.value;
  String? get genus => _species.genus.value;
  SpeciesDataSource get dataSource => _species.dataSource.value;
  String? get base64image => _base64Image;
  int? get light => _speciesCare.light.value;
  int? get humidity => _speciesCare.humidity.value;
  int? get tempMax => _speciesCare.tempMax.value;
  int? get tempMin => _speciesCare.tempMin.value;
  int? get phMin => _speciesCare.phMin.value;
  int? get phMax => _speciesCare.phMax.value;
  List<String> get synonyms =>
      _speciesSynonyms.map((s) => s.synonym.value).toList();
  bool get isExternal => _isExternal;
  SpeciesCareCompanion get care => _speciesCare;
  SpeciesDataSource get source => _species.dataSource.value;
  SpeciesCompanion get speciesObj => _species;

  Future<Result<void>> _load(int speciesId) async {
    Result<Specy> species = await _speciesRepository.get(speciesId);
    if (species.isError()) {
      return Failure(Exception(species.exceptionOrNull()));
    }
    _log.fine("Species loaded");
    _species = species.getOrThrow().toCompanion(true);

    Result<SpeciesCareData> care = await _speciesCareRepository.get(speciesId);
    if (care.isError()) {
      return Failure(Exception(care.exceptionOrNull()));
    }
    _speciesCare = care.getOrThrow().toCompanion(true);
    _log.fine("Species care loaded");

    Result<List<SpeciesSynonym>> synonyms =
        await _speciesSynonymsRepository.getBySpecies(speciesId);
    if (synonyms.isError()) {
      return Failure(Exception(synonyms.exceptionOrNull()));
    }
    _speciesSynonyms =
        synonyms.getOrThrow().map((s) => s.toCompanion(true)).toList();
    _log.fine("Species synonyms loaded");

    Result<String>? speciesImageBase64 =
        await _imageRepository.getSpeciesImageBase64(_species.id.value);
    if (speciesImageBase64 != null) {
      if (speciesImageBase64.isError()) {
        return Failure(Exception(speciesImageBase64.exceptionOrNull()));
      }
      _base64Image = speciesImageBase64.getOrThrow();
    }
    _log.fine("Species image loaded");

    return Success("ok");
  }

  Future<Result<void>> _loadExternal(
      SpeciesSearcherPartialResult external) async {
    Result<SpeciesSearcherResult> details =
        await _speciesSearcherFacade.getDetails(external);
    if (details.isError()) {
      return details;
    }

    _species = external.speciesCompanion;
    _log.fine("External species loaded");

    _speciesCare = details.getOrThrow().speciesCareCompanion;
    _log.fine("External species care loaded");

    _speciesSynonyms = details.getOrThrow().speciesSynonymsCompanion;
    _log.fine("External species synonyms loaded");

    if (details.getOrThrow().speciesCompanion.externalAvatarUrl.present) {
      String url =
          details.getOrThrow().speciesCompanion.externalAvatarUrl.value!;

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        return Failure(Exception("Failed to download image from URL: $url"));
      }
      _log.fine("External species image loaded");
      _base64Image = base64Encode(response.bodyBytes);
    }

    return Success("ok");
  }

  Future<Result<int>> _duplicate() async {
    String duplicatedSpecies = "${_species.species.value} copy";
    Result<int> dupliacatedId =
        await _speciesRepository.insert(_species.copyWith(
      id: Value.absent(),
      species: Value(duplicatedSpecies),
      scientificName: Value(duplicatedSpecies),
      dataSource: Value(SpeciesDataSource.custom),
      externalAvatarUrl: Value.absent(),
    ));
    if (dupliacatedId.isError()) {
      return dupliacatedId;
    }

    Result<int> dupliacatedCareId = await _speciesCareRepository.insert(
        _speciesCare.copyWith(species: Value(dupliacatedId.getOrThrow())));
    if (dupliacatedCareId.isError()) {
      await _speciesRepository.delete(dupliacatedId.getOrThrow());
      return dupliacatedCareId;
    }

    for (SpeciesSynonymsCompanion s in _speciesSynonyms) {
      Result<int> dupliacatedSynonymsId =
          await _speciesSynonymsRepository.insert(s.copyWith(
        id: Value.absent(),
        species: Value(dupliacatedId.getOrThrow()),
      ));
      if (dupliacatedSynonymsId.isError()) {
        await _speciesRepository.delete(dupliacatedId.getOrThrow());
        await _speciesCareRepository.delete(dupliacatedCareId.getOrThrow());
        return dupliacatedSynonymsId;
      }
    }

    if (_base64Image != null) {
      Result<void> duplicatedImage =
          await _duplicateImage(dupliacatedId.getOrThrow());

      if (duplicatedImage.isError()) {
        await _speciesRepository.delete(dupliacatedId.getOrThrow());
        await _speciesCareRepository.delete(dupliacatedId.getOrThrow());
        await _speciesSynonymsRepository
            .deleteBySpecies(dupliacatedId.getOrThrow());
      }
    }

    await _appCache.clearSearch();
    return dupliacatedCareId;
  }

  Future<Result<void>> _duplicateImage(int duplicatedSpeciesId) async {
    if (!isExternal) {
      return await _imageRepository.getSpeciesImage(id!).then((i) async {
        if (i == null) {
          return Success("ok");
        }
        if (i.isError()) {
          return Failure(Exception(i.exceptionOrNull()));
        }
        if (i.getOrThrow().imagePath != null) {
          Result<String> imagePath = await _imageRepository.saveImageFile(
              File(i.getOrThrow().imagePath!),
              path.extension(i.getOrThrow().imagePath!));
          if (imagePath.isError()) {
            return Failure(Exception(imagePath.exceptionOrNull()));
          }
          await _imageRepository.insert(ImagesCompanion(
            imagePath: Value(imagePath.getOrNull()),
            createdAt: Value(DateTime.now()),
            speciesId: Value(duplicatedSpeciesId),
          ));
        } else if (i.getOrThrow().imageUrl != null) {
          await _imageRepository.insert(ImagesCompanion(
            imageUrl: Value(i.getOrThrow().imageUrl),
            createdAt: Value(DateTime.now()),
            speciesId: Value(duplicatedSpeciesId),
          ));
        }
        return Success("ok");
      });
    } else {
      return _imageRepository.insert(ImagesCompanion(
        imageUrl: _species.externalAvatarUrl,
        speciesId: Value(duplicatedSpeciesId),
        createdAt: Value(DateTime.now()),
      ));
    }
  }

  Future<Result<void>> _delete() async {
    if (_isExternal) {
      return Failure(Exception("Cannot delete external species"));
    }

    Result<void> deletedSpecies =
        await _speciesRepository.delete(_species.id.value);
    if (deletedSpecies.isError()) {
      return deletedSpecies;
    }

    Result<void> deletedCare =
        await _speciesCareRepository.delete(_species.id.value);
    if (deletedCare.isError()) {
      return deletedCare;
    }

    await _speciesSynonymsRepository.deleteBySpecies(_species.id.value);

    await _appCache.deleteSpeciesDetails(
        _species.id.value.toString(), SpeciesDataSource.custom);

    await _appCache.clearSearch();

    return deletedSpecies;
  }
}
