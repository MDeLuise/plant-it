import 'package:drift/drift.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/repositories/base_repository.dart';

class SpeciesCareRepository extends BaseRepository<SpeciesCareData> {
  final AppDatabase db;
  final Cache cache;

  SpeciesCareRepository(this.db, this.cache);

  SpeciesCareRepository.fromEnvironment(Environment env)
      : db = env.db,
        cache = env.cache;

  @override
  Future<List<SpeciesCareData>> getAll() async {
    return db.select(db.speciesCare).get();
  }

  @override
  Future<SpeciesCareData> get(int id) {
    return (db.select(db.speciesCare)..where((t) => t.species.equals(id)))
        .watchSingle()
        .first;
  }

  @override
  Future<int> insert(UpdateCompanion<SpeciesCareData> toInsert) {
    return db.into(db.speciesCare).insert(toInsert);
  }

  @override
  void delete(int id) {
    (db.delete(db.speciesCare)..where((t) => t.species.equals(id))).go();
  }

  @override
  Future<bool> update(SpeciesCareData updated) {
    return db.update(db.speciesCare).replace(updated);
  }
}
