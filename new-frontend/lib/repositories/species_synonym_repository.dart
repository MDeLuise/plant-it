import 'package:drift/drift.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/repositories/base_repository.dart';

class SpeciesSynonymsRepository extends BaseRepository<SpeciesSynonym> {
  final AppDatabase db;
  final Cache cache;

  SpeciesSynonymsRepository(this.db, this.cache);

  SpeciesSynonymsRepository.fromEnvironment(Environment env)
      : db = env.db,
        cache = env.cache;

  @override
  Future<List<SpeciesSynonym>> getAll() async {
    return db.select(db.speciesSynonyms).get();
  }

  @override
  Future<SpeciesSynonym> get(int id) {
    return (db.select(db.speciesSynonyms)..where((t) => t.species.equals(id)))
        .watchSingle()
        .first;
  }

  @override
  Future<int> insert(UpdateCompanion<SpeciesSynonym> toInsert) {
    return db.into(db.speciesSynonyms).insert(toInsert);
  }

  @override
  void delete(int id) {
    (db.delete(db.speciesSynonyms)..where((t) => t.species.equals(id))).go();
  }

  @override
  Future<bool> update(SpeciesSynonym updated) {
    return db.update(db.speciesSynonyms).replace(updated);
  }

  Future<List<SpeciesSynonym>> getBySpecies(int speciesId) {
    return (db.select(db.speciesSynonyms)
          ..where((s) => s.species.equals(speciesId)))
        .get();
  }

  Future<void> insertAll(List<UpdateCompanion<SpeciesSynonym>> toInsert) async {
    await db.batch((batch) {
      batch.insertAll(db.speciesSynonyms, toInsert);
    });
  }
}
