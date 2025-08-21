import 'dart:math';

import 'package:plant_it/data/service/search/local_searcher.dart';
import 'package:plant_it/data/service/search/trefle_searcher.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:result_dart/result_dart.dart';

class SpeciesSearcherFacade {
  final LocalSearcher _localSearcher;
  final TrefleSearcher _trefleSearcher;

  SpeciesSearcherFacade({
    required LocalSearcher localSearcher,
    required TrefleSearcher trefleSearcher,
  })  : _localSearcher = localSearcher,
        _trefleSearcher = trefleSearcher;

  Future<Result<List<SpeciesSearcherResult>>> search(String term,
      List<SpeciesDataSource> sources, int offset, int limit) async {
    List<SpeciesSearcherResult> result = [];

    if (sources.contains(SpeciesDataSource.custom)) {
      Result<List<SpeciesSearcherResult>> localResult =
          await _localSearcher.search(term, offset, limit);
      if (localResult.isError()) {
        return Failure(Exception(localResult.exceptionOrNull()));
      }
      result.addAll(localResult.getOrThrow());
    }

    if (sources.contains(SpeciesDataSource.trefle)) {
      Result<List<SpeciesSearcherResult>> trefleResult =
          await _trefleSearcher.search(term, offset, limit);
      if (trefleResult.isError()) {
        return Failure(Exception(trefleResult.exceptionOrNull()));
      }
      result.addAll(trefleResult.getOrThrow());
    }

    return Success(result.sublist(0, min(result.length, limit)));
  }
}
