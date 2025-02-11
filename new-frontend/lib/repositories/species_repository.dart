import 'package:drift/drift.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/repositories/base_repository.dart';
import 'package:plant_it/search/fetcher/species_fetcher.dart';

class SpeciesRepository extends BaseRepository<Specy> {
  final AppDatabase db;
  final Cache cache;

  SpeciesRepository(this.db, this.cache);

  SpeciesRepository.fromEnvironment(Environment env)
      : db = env.db,
        cache = env.cache;

  @override
  Future<List<Specy>> getAll() async {
    return db.select(db.species).get();
  }

  @override
  Future<Specy> get(int id) {
    return (db.select(db.species)..where((t) => t.id.equals(id)))
        .watchSingle()
        .first;
  }

  @override
  Future<int> insert(UpdateCompanion<Specy> toInsert) {
    return db.into(db.species).insertOnConflictUpdate(toInsert);
  }

  @override
  void delete(int id) {
    (db.delete(db.species)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<bool> update(Specy updated) {
    return db.update(db.species).replace(updated);
  }

  Future<List<Specy>> getFiltered(
      String scientificName, Pageable pageable) async {
    final query = db.select(db.species)
      ..where((t) => t.scientificName.like('%$scientificName%'))
      ..limit(pageable.limit, offset: pageable.offset);

    return query.get();
  }

  Future<Specy?> getExternal(SpeciesDataSource dataSource, String externalId) {
    return (db.select(db.species)
          ..where((t) => Expression.and([
                t.dataSource.equals(dataSource.name),
                t.externalId.equals(externalId)
              ])))
        .getSingleOrNull();
  }

  Future<void> insertAll(List<UpdateCompanion<Specy>> toInsert) async {
    await db.batch((batch) {
      batch.insertAll(db.species, toInsert);
    });
  }

  
  Future<List<Specy>> getAllByDataSource(SpeciesDataSource dataSource) async {
    return (db.select(db.species)
          ..where((s) => s.dataSource.equals(dataSource.name)))
        .get();
  }

  
  Future<List<Specy>> getAllByScientificNameAndDataSource(String scientificName,
      SpeciesDataSource dataSource, Pageable pageable) async {
    final query = db.select(db.species)
      ..where((s) => Expression.and([
            s.scientificName.like('%$scientificName%'),
            s.dataSource.equals(dataSource.name)
          ]))
      ..limit(pageable.limit, offset: pageable.offset);

    return query.get();
  }

  
  Future<List<Specy>> getAllByDataSourcePaginated(
      SpeciesDataSource dataSource, Pageable pageable) async {
    return (db.select(db.species)
          ..where((s) => s.dataSource.equals(dataSource.name))
          ..limit(pageable.limit, offset: pageable.offset))
        .get();
  }

  Future<bool> existsTrefle() {
    return db.managers.species
        .filter((s) => s.dataSource.equals(SpeciesDataSource.trefle))
        .exists();
  }
}
