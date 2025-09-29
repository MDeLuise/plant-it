import 'dart:convert';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:plant_it/data/service/search/cache/app_cache.dart';
import 'package:plant_it/data/service/search/flora_codex_searcher.dart';
import 'package:plant_it/data/service/search/local_searcher.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:result_dart/result_dart.dart';

class SpeciesSearcherFacade {
  final LocalSearcher _localSearcher;
  final FloraCodexSearcher _floraCodexSearcher;
  final Logger _log = Logger("SpeciesSearcherFacade");
  final AppCache _cache;

  SpeciesSearcherFacade({
    required LocalSearcher localSearcher,
    required FloraCodexSearcher floraCodexSearcher,
    required AppCache cache,
  })  : _localSearcher = localSearcher,
        _floraCodexSearcher = floraCodexSearcher,
        _cache = cache;

  Future<Result<List<SpeciesSearcherPartialResult>>> search(
      String term, int offset, int limit) async {
    String emptyToAsterisk = term.isEmpty ? AppCache.emptyChar : term;
    List<SpeciesSearcherPartialResult>? cacheResult =
        await _cacheHitSearch(emptyToAsterisk);
    if (cacheResult != null) {
      _log.fine("Cache hit");
      return Success(cacheResult);
    }
    _log.fine("Cache miss");

    List<SpeciesSearcherPartialResult> result = [];

    Result<List<SpeciesSearcherPartialResult>> localResult =
        await _localSearcher.search(term, offset, limit);
    if (localResult.isError()) {
      return Failure(Exception(localResult.exceptionOrNull()));
    }
    result.addAll(localResult.getOrThrow());

    Result<List<SpeciesSearcherPartialResult>> floraCodexResult =
        await _floraCodexSearcher.search(term, offset, limit);
    if (floraCodexResult.isError()) {
      return Failure(Exception(floraCodexResult.exceptionOrNull()));
    }
    result.addAll(floraCodexResult.getOrThrow());

    await _saveCacheSearch(
        emptyToAsterisk, result.sublist(0, min(result.length, limit)));
    return Success(result.sublist(0, min(result.length, limit)));
  }

  Future<Result<SpeciesSearcherResult>> getDetails(
      SpeciesSearcherPartialResult species) async {
    if (species.speciesCompanion.dataSource.value == SpeciesDataSource.custom) {
      String id = species.speciesCompanion.externalId.value ??
          species.speciesCompanion.id.value.toString();
      SpeciesSearcherResult? cached =
          await _cacheHitDetails(id, SpeciesDataSource.custom);
      if (cached != null) {
        return Success(cached);
      }
      Result<SpeciesSearcherResult> result = await _localSearcher
          .getDetails(species.speciesCompanion.id.value.toString());
      if (result.isError()) {
        return result;
      }
      _saveCacheDetails(id, SpeciesDataSource.custom, result.getOrThrow());
      return result;
    } else if (species.speciesCompanion.dataSource.value ==
        SpeciesDataSource.floraCodex) {
      String cacheKey =
          "${species.speciesCompanion.externalId.value}_floraCodex_details";
      SpeciesSearcherResult? cached =
          await _cacheHitDetails(cacheKey, SpeciesDataSource.floraCodex);
      if (cached != null) {
        return Success(cached);
      }
      Result<SpeciesSearcherResult> result = await _floraCodexSearcher
          .getDetails(species.speciesCompanion.externalId.value.toString());
      if (result.isError()) {
        return result;
      }
      _saveCacheDetails(
          cacheKey, SpeciesDataSource.floraCodex, result.getOrThrow());
      return result;
    }
    return Failure(Exception("missing or wrong data source value"));
  }

  Future<List<SpeciesSearcherPartialResult>?> _cacheHitSearch(
      String term) async {
    String? result = _cache.getSpeciesSearch(term);
    if (result == null) {
      return null;
    }
    //_log.fine("cache reading:\n$result");
    List<dynamic> jsonList = jsonDecode(result);
    return jsonList
        .map((json) => SpeciesSearcherPartialResult.fromJson(json))
        .toList()
        .cast<SpeciesSearcherPartialResult>();
  }

  Future<void> _saveCacheSearch(
      String term, List<SpeciesSearcherPartialResult> result) {
    String value = jsonEncode(result
        .map((r) => SpeciesSearcherPartialResult(
              speciesCompanion: r.speciesCompanion,
            ).toJson())
        .toList());
    //_log.fine("cache saving:\n$value");
    return _cache.saveSpeciesSearch(term, value);
  }

  Future<SpeciesSearcherResult?> _cacheHitDetails(
      String id, SpeciesDataSource source) async {
    String? result = _cache.getSpeciesDetails(id, source);
    if (result == null) {
      return null;
    }
    //_log.fine("cache reading:\n$result");
    dynamic json = jsonDecode(result);
    return SpeciesSearcherResult.fromJson(json);
  }

  Future<void> _saveCacheDetails(
      String id, SpeciesDataSource source, SpeciesSearcherResult details) {
    String value = jsonEncode(details);
    //_log.fine("cache saving:\n$value");
    return _cache.saveSpeciesDetails(id, source, value);
  }
}
