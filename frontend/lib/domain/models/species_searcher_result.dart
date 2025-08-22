import 'package:drift/drift.dart';
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

  Map<String, dynamic> toJson() {
    // Map<String, Expression<Object>> speciesCompanionColumns = speciesCompanion.toColumns(true);
    // speciesCompanionColumns.keys.map((k) {
    //       return "'$k': '${speciesCompanionColumns[k]!.toString()}'";
    //     }).join(",\n");
    return {
      'speciesDataSource': speciesDataSource.toString(),
      'speciesCompanion': {
        'id': speciesCompanion.id.value,
        'scientificName': speciesCompanion.scientificName.value,
        'family': speciesCompanion.family.value,
        'genus': speciesCompanion.genus.value,
        'species': speciesCompanion.species.value,
        'author': speciesCompanion.author.value,
        'dataSource': speciesCompanion.dataSource.value.toString(),
        'externalId': speciesCompanion.externalId.value,
        'externalAvatarUrl': speciesCompanion.externalAvatarUrl.value,
        'year': speciesCompanion.year.value,
        'bibliography': speciesCompanion.bibliography.value,
      },
      'speciesCareCompanion': {
        'species': speciesCareCompanion.species.value,
        'light': speciesCareCompanion.light.value,
        'humidity': speciesCareCompanion.humidity.value,
        'tempMax': speciesCareCompanion.tempMax.value,
        'tempMin': speciesCareCompanion.tempMin.value,
        'phMin': speciesCareCompanion.phMin.value,
        'phMax': speciesCareCompanion.phMax.value,
      },
      'speciesSynonymsCompanion': speciesSynonymsCompanion
          .map((synonym) => {
                'id': synonym.id.value,
                'species': synonym.species.value,
                'synonym': synonym.synonym.value,
              })
          .toList(),
    };
  }

  factory SpeciesSearcherResult.fromJson(Map<String, dynamic> json) {
    return SpeciesSearcherResult(
      speciesDataSource: SpeciesDataSource.values
          .firstWhere((e) => e.toString() == json['speciesDataSource']),
      speciesCompanion: SpeciesCompanion(
        id: Value(json['speciesCompanion']['id']),
        scientificName: Value(json['speciesCompanion']['scientificName']),
        family: Value(json['speciesCompanion']['family']),
        genus: Value(json['speciesCompanion']['genus']),
        species: Value(json['speciesCompanion']['species']),
        author: Value(json['speciesCompanion']['author']),
        dataSource: Value(SpeciesDataSource.values.firstWhere(
            (e) => e.toString() == json['speciesCompanion']['dataSource'])),
        externalId: Value(json['speciesCompanion']['externalId']),
        externalAvatarUrl: Value(json['speciesCompanion']['externalAvatarUrl']),
        year: Value(json['speciesCompanion']['year']),
        bibliography: Value(json['speciesCompanion']['bibliography']),
      ),
      speciesCareCompanion: SpeciesCareCompanion(
        species: Value(json['speciesCareCompanion']['species']),
        light: Value(json['speciesCareCompanion']['light']),
        humidity: Value(json['speciesCareCompanion']['humidity']),
        tempMax: Value(json['speciesCareCompanion']['tempMax']),
        tempMin: Value(json['speciesCareCompanion']['tempMin']),
        phMin: Value(json['speciesCareCompanion']['phMin']),
        phMax: Value(json['speciesCareCompanion']['phMax']),
      ),
      speciesSynonymsCompanion: (json['speciesSynonymsCompanion'] as List)
          .map((synonymJson) => SpeciesSynonymsCompanion(
                id: Value(synonymJson['id']),
                species: Value(synonymJson['species']),
                synonym: Value(synonymJson['synonym']),
              ))
          .toList(),
    );
  }
}
