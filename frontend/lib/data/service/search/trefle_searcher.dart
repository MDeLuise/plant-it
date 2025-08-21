import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/species_care_repository.dart';
import 'package:plant_it/data/repository/species_repository.dart';
import 'package:plant_it/data/repository/species_synonym_repository.dart';
import 'package:plant_it/data/service/search/species_searcher.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:result_dart/result_dart.dart';

class TrefleSearcher extends SpeciesSearcher {
  final SpeciesRepository _speciesRepository;
  final SpeciesCareRepository _speciesCareRepository;
  final SpeciesSynonymsRepository _speciesSynonymsRepository;
  final Logger _log = Logger("TrefleSearcher");

  TrefleSearcher({
    required SpeciesRepository speciesRepository,
    required SpeciesCareRepository speciesCareRepository,
    required SpeciesSynonymsRepository speciesSynonymsRepository,
  })  : _speciesRepository = speciesRepository,
        _speciesCareRepository = speciesCareRepository,
        _speciesSynonymsRepository = speciesSynonymsRepository;

  @override
  Future<Result<List<SpeciesSearcherResult>>> search(
      String term, int offset, int limit) async {
    List<SpeciesSearcherResult> result = [];
    Result<List<Specy>> species =
        await _speciesRepository.getAllByScientificNameOrSynonymsAndDataSource(
            term, SpeciesDataSource.trefle, offset, limit);
    if (species.isError()) {
      return Failure(Exception(species.exceptionOrNull()));
    }
    _log.fine("Loaded asked species");

    for (Specy s in species.getOrThrow()) {
      Result<SpeciesCareData> care = await _speciesCareRepository.get(s.id);
      if (care.isError()) {
        return Failure(Exception(care.exceptionOrNull()));
      }
      _log.fine("Loaded asked species care");

      Result<List<SpeciesSynonym>> synonyms =
          await _speciesSynonymsRepository.getBySpecies(s.id);
      if (synonyms.isError()) {
        return Failure(Exception(synonyms.exceptionOrNull()));
      }
      _log.fine("Loaded asked species synonyms");

      result.add(SpeciesSearcherResult(
        speciesDataSource: SpeciesDataSource.trefle,
        speciesCompanion: s.toCompanion(true),
        speciesCareCompanion: care.getOrThrow().toCompanion(true),
        speciesSynonymsCompanion:
            synonyms.getOrThrow().map((r) => r.toCompanion(true)).toList(),
      ));
    }
    return Success(result);
  }
}
