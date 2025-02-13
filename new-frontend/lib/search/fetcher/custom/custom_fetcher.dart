import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/search/fetcher/species_fetcher.dart';

class CustomFetcher extends SpeciesFetcher {
  final Environment env;

  CustomFetcher(this.env);

  @override
  Future<List<SpeciesCompanion>> fetch(
      String partialScientificName, Pageable pageable) {
    return env.speciesRepository
        .getAllByScientificNameOrSynonymsAndDataSource(
            partialScientificName, SpeciesDataSource.custom, pageable)
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
          dataSource: const Value(SpeciesDataSource.custom),
        );
      }).toList();
    });
  }

  @override
  Future<List<SpeciesCompanion>> fetchAll(Pageable pageable) {
    return env.speciesRepository
        .getAllByDataSourcePaginated(SpeciesDataSource.custom, pageable)
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
          dataSource: const Value(SpeciesDataSource.custom),
        );
      }).toList();
    });
  }

  @override
  SpeciesDataSource getSpeciesDataSource() {
    return SpeciesDataSource.custom;
  }

  @override
  Future<SpeciesCareCompanion> getCare(SpeciesCompanion speciesCompanion) {
    return env.speciesCareRepository.get(speciesCompanion.id.value).then((r) {
      return Future.value(SpeciesCareCompanion(
        species: Value(r.species),
        light: Value(r.light),
        humidity: Value(r.humidity),
        tempMin: Value(r.tempMin),
        tempMax: Value(r.tempMax),
        phMin: Value(r.phMin),
        phMax: Value(r.phMax),
      ));
    });
  }

  @override
  Future<List<String>> getSynonyms(SpeciesCompanion speciesCompanion) {
    return env.speciesSynonymsRepository
        .getBySpecies(speciesCompanion.id.value)
        .then((r) {
      return r.map((s) => s.synonym).toList();
    });
  }
}
