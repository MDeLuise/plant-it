import 'package:drift/drift.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/repositories/base_repository.dart';
import 'package:plant_it/search/species_fetcher.dart';

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
    return db.into(db.species).insert(toInsert);
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
}
