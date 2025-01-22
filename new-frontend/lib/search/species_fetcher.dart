import 'package:plant_it/database/database.dart';

class SpeciesFetcherFacade {
  final List<SpeciesFetcher> chain = [];

  void addNext(SpeciesFetcher next) {
    chain.add(next);
  }

  Future<List<SpeciesCompanion>> fetch(
      String partialScientificName, Pageable pageable) async {
    final List<SpeciesCompanion> result = [];
    for (SpeciesFetcher pf in chain) {
      final List<SpeciesCompanion> retrieved = await pf.fetch(partialScientificName, pageable);
      result.addAll(retrieved);
    }
    return result;
  }
}

abstract class SpeciesFetcher {
  Future<List<SpeciesCompanion>> fetch(String partialScientificName, Pageable pageable);
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
