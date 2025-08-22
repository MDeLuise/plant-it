import 'package:plant_it/data/service/search/species_searcher.dart';
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:result_dart/result_dart.dart';

class FloraCodexSearcher extends SpeciesSearcher {
  @override
  Future<Result<List<SpeciesSearcherResult>>> search(String term, int offset, int limit) {
    throw UnimplementedError();
  }
}