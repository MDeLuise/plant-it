import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/data/repository/crud_repository.dart';
import 'package:result_dart/result_dart.dart';

class SpeciesRepository extends CRUDRepository<Specy> {
  SpeciesRepository({required super.db});

  @override
  TableInfo<Table, Specy> get table => db.species;

  Future<Result<List<Specy>>> getFiltered(
      String scientificName, int offset, int limit) async {
    var query = db.select(db.species)
      ..where((t) => t.scientificName.like('%$scientificName%'))
      ..limit(limit, offset: offset);

    return (await query.get()).toSuccess();
  }

  Future<Result<Specy>?> getExternal(
      SpeciesDataSource dataSource, String externalId) async {
    Specy? species = await (db.select(db.species)
          ..where((t) => Expression.and([
                t.dataSource.equals(dataSource.name),
                t.externalId.equals(externalId)
              ])))
        .getSingleOrNull();
    return species?.toSuccess();
  }

  Future<Result<List<Specy>>> getAllByDataSource(
      SpeciesDataSource dataSource) async {
    List<Specy> species = await (db.select(db.species)
          ..where((s) => s.dataSource.equals(dataSource.name)))
        .get();
    return species.toSuccess();
  }

  Future<Result<List<Specy>>> getAllByScientificNameAndDataSource(
      String scientificName,
      SpeciesDataSource dataSource,
      int offset,
      int limit) async {
    var query = db.select(db.species)
      ..where((s) => Expression.and([
            s.scientificName.like('%$scientificName%'),
            s.dataSource.equals(dataSource.name)
          ]))
      ..limit(limit, offset: offset);

    return (await query.get()).toSuccess();
  }

  Future<Result<List<Specy>>> getAllBySynonymsAndDataSource(
      String scientificName,
      SpeciesDataSource dataSource,
      int offset,
      int limit) async {
    var query = db.select(db.species).join([
      innerJoin(db.speciesSynonyms,
          db.speciesSynonyms.species.equalsExp(db.species.id))
    ])
      ..where(db.speciesSynonyms.synonym.like('%$scientificName%'))
      ..where(db.species.dataSource.equals(dataSource.name))
      ..limit(limit, offset: offset);

    return (await query.map((row) => row.readTable(db.species)).get())
        .toSuccess();
  }

  Future<Result<List<Specy>>> getAllByScientificNameOrSynonymsAndDataSource(
      String scientificName,
      SpeciesDataSource dataSource,
      int offset,
      int limit) async {
    var query = db.select(db.species).join([
      leftOuterJoin(db.speciesSynonyms,
          db.speciesSynonyms.species.equalsExp(db.species.id))
    ])
      ..where(Expression.or([
        db.species.scientificName.like('%$scientificName%'),
        db.speciesSynonyms.synonym.like('%$scientificName%')
      ]))
      ..where(db.species.dataSource.equals(dataSource.name))
      ..limit(limit, offset: offset);

    // Remove duplicates
    List<Specy> speciesList =
        await query.map((row) => row.readTable(db.species)).get();
    return speciesList.toSet().toList().toSuccess();
  }

  Future<Result<List<Specy>>> getAllByDataSourcePaginated(
      SpeciesDataSource dataSource, int offset, int limit) async {
    List<Specy> species = await (db.select(db.species)
          ..where((s) => s.dataSource.equals(dataSource.name))
          ..limit(limit, offset: offset))
        .get();
    return species.toSuccess();
  }

  Future<Result<bool>> existsTrefle() async {
    bool exists = await db.managers.species
        .filter((s) => s.dataSource.equals(SpeciesDataSource.trefle))
        .exists();
    return exists.toSuccess();
  }

  void deleteAllByDataSources(SpeciesDataSource dataSource) async{
    await (db.delete(db.species)..where((s) => s.dataSource.equals(dataSource.name))).go();
  }
}
