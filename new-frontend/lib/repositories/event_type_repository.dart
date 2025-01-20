import 'package:drift/drift.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/repositories/base_repository.dart';

class EventTypeRepository extends BaseRepository<EventType> {
  final AppDatabase db;
  final Cache cache;

  EventTypeRepository(this.db, this.cache);

  EventTypeRepository.fromEnvironment(Environment env)
      : db = env.db,
        cache = env.cache;

  @override
  Future<List<EventType>> getAll() async {
    return db.select(db.eventTypes).get();
  }

  @override
  Future<EventType> get(int id) {
    return (db.select(db.eventTypes)..where((t) => t.id.equals(id)))
        .watchSingle()
        .first;
  }

  @override
  Future<int> insert(UpdateCompanion<EventType> toInsert) {
    return db.into(db.eventTypes).insert(toInsert);
  }

  @override
  void delete(int id) {
    (db.delete(db.eventTypes)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<bool> update(EventType updated) {
    return db.update(db.eventTypes).replace(updated);
  }
}
