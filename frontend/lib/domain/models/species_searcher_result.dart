import 'package:plant_it/database/database.dart';

class SpeciesSearcherResult {
  final SpeciesDataSource speciesDataSource;
  final SpeciesCompanion speciesCompanion;
  final SpeciesCareCompanion speciesCareCompanion;
  final List<SpeciesSynonymsCompanion> speciesSynonymsCompanion;

  SpeciesSearcherResult({
    required this.speciesDataSource,
    required this.speciesCompanion,
    required this.speciesCareCompanion,
    required this.speciesSynonymsCompanion,
  });
}
