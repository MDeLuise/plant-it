import 'package:drift/drift.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';

class UserSettingRepository {
  final AppDatabase db;
  final Cache cache;

  UserSettingRepository(this.db, this.cache);

  UserSettingRepository.fromEnvironment(Environment env)
      : db = env.db,
        cache = env.cache;

  Future<String> getOrDefault(String key, String defaultValue) async {
    final result = await (db.select(db.userSettings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();

    if (result != null) {
      return result.value;
    } else {
      return defaultValue;
    }
  }

  void put(String key, String value) async {
    db.into(db.userSettings).insertOnConflictUpdate(UserSettingsCompanion(
          key: Value(key),
          value: Value(value),
        ));
  }

  Future<bool> exists(String key) async {
    final List<UserSetting> stored = await (db.select(db.userSettings)
          ..where((t) => t.key.equals(key)))
        .get();
    return stored.isNotEmpty;
  }
}
