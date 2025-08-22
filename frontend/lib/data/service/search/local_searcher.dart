import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/species_care_repository.dart';
import 'package:plant_it/data/repository/species_repository.dart';
import 'package:plant_it/data/repository/species_synonym_repository.dart';
import 'package:plant_it/data/service/search/species_searcher.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:result_dart/result_dart.dart';

class LocalSearcher extends SpeciesSearcher {
  final SpeciesRepository _speciesRepository;
  final SpeciesCareRepository _speciesCareRepository;
  final SpeciesSynonymsRepository _speciesSynonymsRepository;
  final Logger _log = Logger("LocalSearcher");

  LocalSearcher({
    required SpeciesRepository speciesRepository,
    required SpeciesCareRepository speciesCareRepository,
    required SpeciesSynonymsRepository speciesSynonymsRepository,
  })  : _speciesRepository = speciesRepository,
        _speciesCareRepository = speciesCareRepository,
        _speciesSynonymsRepository = speciesSynonymsRepository;

  @override
  Future<Result<List<SpeciesSearcherPartialResult>>> search(
      String term, int offset, int limit) async {
    Result<List<Specy>> species =
        await _speciesRepository.getAllByScientificNameOrSynonymsAndDataSource(
            term, SpeciesDataSource.custom, offset, limit);
    if (species.isError()) {
      return Failure(Exception(species.exceptionOrNull()));
    }
    _log.fine("Loaded asked species");

    return Success(species.getOrThrow().map((s) {
      return SpeciesSearcherPartialResult(
        speciesCompanion: s.toCompanion(true),
      );
    }).toList());
  }

  @override
  Future<Result<SpeciesSearcherResult>> getDetails(int id) async {
    Result<Specy> species = await _speciesRepository.get(id);
    if (species.isError()) {
      return Failure(Exception(species.exceptionOrNull()));
    }
    _log.fine("Loaded asked species");

    Result<SpeciesCareData> care =
        await _speciesCareRepository.get(species.getOrThrow().id);
    if (care.isError()) {
      return Failure(Exception(care.exceptionOrNull()));
    }
    _log.fine("Loaded asked species care");

    Result<List<SpeciesSynonym>> synonyms =
        await _speciesSynonymsRepository.getBySpecies(species.getOrThrow().id);
    if (synonyms.isError()) {
      return Failure(Exception(synonyms.exceptionOrNull()));
    }
    _log.fine("Loaded asked species synonyms");

    return Success(
      SpeciesSearcherResult(
        speciesCompanion: species.getOrThrow().toCompanion(true),
        speciesCareCompanion: care.getOrThrow().toCompanion(true),
        speciesSynonymsCompanion: synonyms.getOrThrow().map((s) {
          return s.toCompanion(true);
        }).toList(),
      ),
    );
  }
}
