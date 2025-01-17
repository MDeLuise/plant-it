import 'package:drift/drift.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/repositories/base_repository.dart';

class EventRepository extends BaseRepository<Event> {
  final AppDatabase db;
  final Cache cache;

  EventRepository(this.db, this.cache);

  EventRepository.fromEnvironment(Environment env)
      : db = env.db,
        cache = env.cache;

  @override
  Future<List<Event>> getAll() async {
    return db.select(db.events).get();
  }

  @override
  Future<Event> get(int id) {
    return (db.select(db.events)..where((t) => t.id.equals(id))).watchSingle().first;
  }

  @override
  Future<int> insert(UpdateCompanion<Event> toInsert) {
    return db.into(db.events).insert(toInsert);
  }
}
