import 'package:drift/drift.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/repositories/base_repository.dart';

class ReminderRepository extends BaseRepository<Reminder> {
  final AppDatabase db;
  final Cache cache;

  ReminderRepository(this.db, this.cache);

  ReminderRepository.fromEnvironment(Environment env)
      : db = env.db,
        cache = env.cache;

  @override
  Future<List<Reminder>> getAll() async {
    return db.select(db.reminders).get();
  }

  @override
  Future<Reminder> get(int id) {
    return (db.select(db.reminders)..where((t) => t.id.equals(id)))
        .watchSingle()
        .first;
  }

  @override
  Future<int> insert(UpdateCompanion<Reminder> toInsert) {
    return db.into(db.reminders).insert(toInsert);
  }

  @override
  void delete(int id) {
    (db.delete(db.reminders)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<bool> update(Reminder updated) async {
    return db.update(db.reminders).replace(updated);
  }
}
