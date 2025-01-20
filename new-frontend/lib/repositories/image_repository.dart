import 'package:drift/drift.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/repositories/base_repository.dart';

class ImageRepository extends BaseRepository<Image> {
  final AppDatabase db;
  final Cache cache;

  ImageRepository(this.db, this.cache);

  ImageRepository.fromEnvironment(Environment env)
      : db = env.db,
        cache = env.cache;

  @override
  Future<List<Image>> getAll() async {
    return db.select(db.images).get();
  }

  @override
  Future<Image> get(int id) {
    return (db.select(db.images)..where((t) => t.id.equals(id)))
        .watchSingle()
        .first;
  }

  @override
  Future<int> insert(UpdateCompanion<Image> toInsert) {
    return db.into(db.images).insert(toInsert);
  }

  @override
  void delete(int id) {
    (db.delete(db.images)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<bool> update(Image updated) async {
    return db.update(db.images).replace(updated);
  }
}
