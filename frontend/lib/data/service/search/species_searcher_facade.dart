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
    required FloraCodexSearcher trefleSearcher,
    required AppCache cache,
  })  : _localSearcher = localSearcher,
        _floraCodexSearcher = trefleSearcher,
        _cache = cache;

  Future<Result<List<SpeciesSearcherPartialResult>>> search(
      String term, int offset, int limit) async {
    String cacheKey = term.isEmpty ? "*" : term;
    cacheKey += "_partial";
    List<SpeciesSearcherPartialResult>? cacheResult =
        await _cacheHitPartials(cacheKey);
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

    await _saveCachePartials(
        cacheKey, result.sublist(0, min(result.length, limit)));
    return Success(result.sublist(0, min(result.length, limit)));
  }

  Future<Result<SpeciesSearcherResult>> getDetails(
      SpeciesSearcherPartialResult species) async {
    if (species.speciesCompanion.dataSource.value == SpeciesDataSource.custom) {
      String cacheKey = "${species.speciesCompanion.id.value}_custom_details";
      SpeciesSearcherResult? cached = await _cacheHitDetails(cacheKey);
      if (cached != null) {
        return Success(cached);
      }
      Result<SpeciesSearcherResult> result = await _localSearcher
          .getDetails(species.speciesCompanion.id.value.toString());
      if (result.isError()) {
        return result;
      }
      _saveCacheDetails(cacheKey, result.getOrThrow());
      return result;
    } else if (species.speciesCompanion.dataSource.value ==
        SpeciesDataSource.floraCodex) {
      String cacheKey =
          "${species.speciesCompanion.externalId.value}_floraCodex_details";
      SpeciesSearcherResult? cached = await _cacheHitDetails(cacheKey);
      if (cached != null) {
        return Success(cached);
      }
      Result<SpeciesSearcherResult> result = await _floraCodexSearcher
          .getDetails(species.speciesCompanion.externalId.value.toString());
      if (result.isError()) {
        return result;
      }
      _saveCacheDetails(cacheKey, result.getOrThrow());
      return result;
    }
    return Failure(Exception("missing or wrong data source value"));
  }

  Future<List<SpeciesSearcherPartialResult>?> _cacheHitPartials(
      String key) async {
    String? result = _cache.get(key);
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

  Future<void> _saveCachePartials(
      String key, List<SpeciesSearcherPartialResult> result) {
    String value = jsonEncode(result
        .map((r) => SpeciesSearcherPartialResult(
              speciesCompanion: r.speciesCompanion,
            ).toJson())
        .toList());
    //_log.fine("cache saving:\n$value");
    return _cache.put(key, value);
  }

  Future<SpeciesSearcherResult?> _cacheHitDetails(String key) async {
    String? result = _cache.get(key);
    if (result == null) {
      return null;
    }
    //_log.fine("cache reading:\n$result");
    dynamic json = jsonDecode(result);
    return SpeciesSearcherResult.fromJson(json);
  }

  Future<void> _saveCacheDetails(String key, SpeciesSearcherResult details) {
    String value = jsonEncode(details);
    //_log.fine("cache saving:\n$value");
    return _cache.put(key, value);
  }

  Future<bool> clearCache() async {
    return _cache.clear();
  }
}
