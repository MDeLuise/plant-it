import 'package:command_it/command_it.dart';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/image_repository.dart';
import 'package:plant_it/data/repository/species_care_repository.dart';
import 'package:plant_it/data/repository/species_repository.dart';
import 'package:plant_it/data/repository/species_synonym_repository.dart';
import 'package:plant_it/data/service/search/cache/app_cache.dart';
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
  })  : _speciesRepository = speciesRepository,
        _speciesCareRepository = speciesCareRepository,
        _speciesSynonymsRepository = speciesSynonymsRepository,
        _imageRepository = imageRepository,
        _appCache = appCache {
    load = Command.createAsyncNoResult((dynamic idOrExternal) async {
      if (idOrExternal is int) {
        Result<void> result = await _load(idOrExternal);
        if (result.isError()) throw result.exceptionOrNull()!;
        return result.getOrThrow();
      } else if (idOrExternal is SpeciesSearcherResult) {
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
    }, initialValue: Exception('not started'));
  }

  final SpeciesRepository _speciesRepository;
  final SpeciesCareRepository _speciesCareRepository;
  final SpeciesSynonymsRepository _speciesSynonymsRepository;
  final ImageRepository _imageRepository;
  final AppCache _appCache;
  final _log = Logger('ViewSpeciesViewModel');

  late final Command<int, void> load;
  late final Command<SpeciesSearcherResult, void> loadExternal;
  late final Command<void, void> duplicate;
  late final Command<void, void> delete;

  late SpeciesCompanion _species;
  late SpeciesCareCompanion _speciesCare;
  late List<SpeciesSynonymsCompanion> _speciesSynonyms = [];
  String? _base64Image;
  bool _isExternal = false;

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

  Future<Result<void>> _loadExternal(SpeciesSearcherResult external) async {
    _species = external.speciesCompanion;
    _log.fine("External species loaded");

    _speciesCare = external.speciesCareCompanion;
    _log.fine("External species care loaded");

    _speciesSynonyms = external.speciesSynonymsCompanion;
    _log.fine("External species synonyms loaded");

    return Success("ok");
  }

  Future<Result<int>> _duplicate() async {
    String duplicatedSpecies = "${_species.species.value} copy";
    Result<int> dupliacatedId =
        await _speciesRepository.insert(_species.copyWith(
      id: null,
      species: Value(duplicatedSpecies),
      scientificName: Value(duplicatedSpecies),
      dataSource: Value(SpeciesDataSource.custom),
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
      Result<int> dupliacatedSynonymsId = await _speciesSynonymsRepository
          .insert(s.copyWith(species: Value(dupliacatedId.getOrThrow())));
      if (dupliacatedSynonymsId.isError()) {
        await _speciesRepository.delete(dupliacatedId.getOrThrow());
        await _speciesCareRepository.delete(dupliacatedCareId.getOrThrow());
        return dupliacatedSynonymsId;
      }
    }
    return dupliacatedCareId;
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

    return deletedSpecies;
  }
}
