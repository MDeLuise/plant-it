import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/search/species_fetcher.dart';

class LocalFetcher extends SpeciesFetcher {
  final Environment env;

  LocalFetcher(this.env);

  @override
  Future<List<SpeciesCompanion>> fetch(
      String partialScientificName, Pageable pageable) {
    return env.speciesRepository
        .getFiltered(partialScientificName, pageable)
        .then((rl) {
      return rl.map((s) {
        return SpeciesCompanion(
          id: Value(s.id),
          scientificName: Value(s.scientificName),
          family: Value(s.family),
          genus: Value(s.genus),
          species: Value(s.species),
          author: Value(s.author),
          avatarUrl: Value(s.avatarUrl),
          avatar: Value(s.avatar),
        );
      }).toList();
    });
  }
}
