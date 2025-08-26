import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/data/repository/crud_repository.dart';
import 'package:result_dart/result_dart.dart';

class SpeciesSynonymsRepository extends CRUDRepository<SpeciesSynonym> {
  SpeciesSynonymsRepository({required super.db});

  @override
  TableInfo<Table, SpeciesSynonym> get table => db.speciesSynonyms;

  Future<Result<List<SpeciesSynonym>>> getBySpecies(int speciesId) async {
    List<SpeciesSynonym> speciesSynonyms = await (db.select(db.speciesSynonyms)
          ..where((s) => s.species.equals(speciesId)))
        .get();
    return speciesSynonyms.toSuccess();
  }

  Future<int> deleteBySpecies(int speciesId) async {
    return (db.delete(db.speciesSynonyms)
          ..where((s) => s.species.equals(speciesId)))
        .go();
  }
}
