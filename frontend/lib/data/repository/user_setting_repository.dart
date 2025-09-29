import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class UserSettingRepository {
  final AppDatabase db;

  UserSettingRepository({
    required this.db,
  });

  Future<Result<String>> getOrDefault(String key, String defaultValue) async {
    UserSetting? result = await (db.select(db.userSettings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();

    if (result != null) {
      return result.value.toSuccess();
    } else {
      return defaultValue.toSuccess();
    }
  }

  Future<Result<void>> put(String key, String value) async {
    await db.into(db.userSettings).insertOnConflictUpdate(UserSettingsCompanion(
          key: Value(key),
          value: Value(value),
        ));
    return Success("ok");
  }

  Future<Result<bool>> exists(String key) async {
    List<UserSetting> stored = await (db.select(db.userSettings)
          ..where((t) => t.key.equals(key)))
        .get();
    return stored.isNotEmpty.toSuccess();
  }

  Future<Result<List<UserSetting>>> getAll() async {
    try {
      List<UserSetting> userSettings = await db.select(db.userSettings).get();
      return Success(userSettings);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void>> remove(String key) async {
    try {
      await (db.delete(db.userSettings)..where((s) => s.key.equals(key))).go();
      return Success("ok");
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
