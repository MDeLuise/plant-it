import 'package:drift/drift.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/repositories/base_repository.dart';

class PlantRepository extends BaseRepository<Plant> {
  final AppDatabase db;
  final Cache cache;

  PlantRepository(this.db, this.cache);

  PlantRepository.fromEnvironment(Environment env)
      : db = env.db,
        cache = env.cache;

  @override
  Future<List<Plant>> getAll() async {
    return db.select(db.plants).get();
  }

  @override
  Future<Plant> get(int id) {
    return (db.select(db.plants)..where((t) => t.id.equals(id)))
        .watchSingle()
        .first;
  }

  @override
  Future<int> insert(UpdateCompanion<Plant> toInsert) {
    return db.into(db.plants).insert(toInsert);
  }

  @override
  void delete(int id) {
    (db.delete(db.plants)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<bool> update(Plant updated) {
    return db.update(db.plants).replace(updated);
  }
}
