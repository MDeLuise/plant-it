import 'package:plant_it/database/database.dart';

class SpeciesFetcherFacade {
  final List<SpeciesFetcher> chain = [];

  void addNext(SpeciesFetcher next) {
    chain.add(next);
  }

  Future<List<SpeciesCompanion>> fetch(
      String partialScientificName, Pageable pageable) async {
    if (partialScientificName == "") {
      return fetchAll(pageable);
    }
    final List<SpeciesCompanion> result = [];
    for (SpeciesFetcher pf in chain) {
      final List<SpeciesCompanion> retrieved =
          await pf.fetch(partialScientificName, pageable);
      result.addAll(retrieved);
    }
    return result;
  }

  Future<List<SpeciesCompanion>> fetchAll(Pageable pageable) async {
    final List<SpeciesCompanion> result = [];
    for (SpeciesFetcher pf in chain) {
      final List<SpeciesCompanion> retrieved = await pf.fetchAll(pageable);
      result.addAll(retrieved);
    }
    return result;
  }

  Future<List<String>> getSynonyms(SpeciesCompanion speciesCompanion) {
    for (SpeciesFetcher fetcher in chain) {
      if (speciesCompanion.dataSource.value == fetcher.getSpeciesDataSource()) {
        return fetcher.getSynonyms(speciesCompanion);
      }
    }
    throw Exception("Cannot find the correct fetcher for the species");
  }

  Future<SpeciesCareCompanion> getCare(SpeciesCompanion speciesCompanion) {
    for (SpeciesFetcher fetcher in chain) {
      if (speciesCompanion.dataSource.value == fetcher.getSpeciesDataSource()) {
        return fetcher.getCare(speciesCompanion);
      }
    }
    throw Exception("Cannot find the correct fetcher for the species");
  }
}

abstract class SpeciesFetcher {
  Future<List<SpeciesCompanion>> fetch(
      String partialScientificName, Pageable pageable);
  Future<List<SpeciesCompanion>> fetchAll(Pageable pageable);
  Future<List<String>> getSynonyms(SpeciesCompanion speciesCompanion);
  Future<SpeciesCareCompanion> getCare(SpeciesCompanion speciesCompanion);
  SpeciesDataSource getSpeciesDataSource();
}

class Pageable {
  int offset;
  int pageNo;
  int limit;

  Pageable()
      : offset = 0,
        pageNo = 0,
        limit = 10;
}
