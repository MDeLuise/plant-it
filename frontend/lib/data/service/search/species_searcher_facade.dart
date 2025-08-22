import 'dart:convert';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:plant_it/data/service/search/flora_codex_searcher.dart';
import 'package:plant_it/data/service/search/local_searcher.dart';
import 'package:plant_it/data/service/search/cache/search_result_cache.dart';
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:result_dart/result_dart.dart';

class SpeciesSearcherFacade {
  final LocalSearcher _localSearcher;
  final FloraCodexSearcher _floraCodexSearcher;
  final Logger _log = Logger("SpeciesSearcherFacade");
  final SearchResultCache _cache;

  SpeciesSearcherFacade({
    required LocalSearcher localSearcher,
    required FloraCodexSearcher trefleSearcher,
    required SearchResultCache cache,
  })  : _localSearcher = localSearcher,
        _floraCodexSearcher = trefleSearcher,
        _cache = cache;

  Future<Result<List<SpeciesSearcherPartialResult>>> search(
      String term, int offset, int limit) async {
    String cacheTerm = term.isEmpty ? "*" : term;
    List<SpeciesSearcherPartialResult>? cacheResult =
        await _cacheHit(cacheTerm, offset, limit);
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

    Result<List<SpeciesSearcherPartialResult>> trefleResult =
        await _floraCodexSearcher.search(term, offset, limit);
    if (trefleResult.isError()) {
      return Failure(Exception(trefleResult.exceptionOrNull()));
    }
    result.addAll(trefleResult.getOrThrow());

    await _saveCache(cacheTerm, result.sublist(0, min(result.length, limit)));
    return Success(result.sublist(0, min(result.length, limit)));
  }

  // TODO get details (with cache)

  Future<List<SpeciesSearcherPartialResult>?> _cacheHit(
      String term, int offset, int limit) async {
    String? result = _cache.get(term);
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

  Future<void> _saveCache(String term, List<SpeciesSearcherPartialResult> result) {
    String value = jsonEncode(result
        .map((r) => SpeciesSearcherPartialResult(
              speciesCompanion: r.speciesCompanion,
            ).toJson())
        .toList());
    //_log.fine("cache saving:\n$value");
    return _cache.put(term, value);
  }

  Future<bool> clearCache() async {
    return _cache.clear();
  }
}
