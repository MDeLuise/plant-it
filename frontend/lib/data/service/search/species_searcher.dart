import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:result_dart/result_dart.dart';

abstract class SpeciesSearcher {
  Future<Result<List<SpeciesSearcherPartialResult>>> search(
      String term, int offset, int limit);

  Future<Result<SpeciesSearcherResult>> getDetails(String id);
}
