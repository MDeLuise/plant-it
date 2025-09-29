import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

class NotificationsLangRepository {
  final AppDatabase db;

  NotificationsLangRepository({
    required this.db,
  });

  Future<Result<void>> put(bool isTitle, String value) async {
    await db
        .into(db.notificationTranslations)
        .insertOnConflictUpdate(NotificationTranslationsCompanion(
          title: Value(isTitle),
          value: Value(value),
        ));
    return Success("ok");
  }

  Future<Result<String>> getRandomTitle() async {
    try {
      final query = db.select(db.notificationTranslations)
        ..where((tbl) => tbl.title.equals(true))
        ..orderBy([(tbl) => OrderingTerm.random()])
        ..limit(1);

      final result = await query.get();

      if (result.isNotEmpty) {
        return Success(result.first.value);
      } else {
        return Failure(Exception("No titles found"));
      }
    } catch (e) {
      return Failure(Exception("Error fetching random title: $e"));
    }
  }

  Future<Result<String>> getRandomBody() async {
    try {
      final query = db.select(db.notificationTranslations)
        ..where((tbl) => tbl.title.equals(false))
        ..orderBy([(tbl) => OrderingTerm.random()]);

      final result = await query.get();

      if (result.isNotEmpty) {
        return Success(result.first.value);
      } else {
        return Failure(Exception("No bodies found"));
      }
    } catch (e) {
      return Failure(Exception("Error fetching random body: $e"));
    }
  }

  Future<Result<int>> count() async {
    int count = await db.managers.notificationTranslations.count();
    return count.toSuccess();
  }

  Future<Result<bool>> isEmpty() async {
    Result<int> entriesNum = await count();
    if (entriesNum.isError()) {
      return Failure(entriesNum.exceptionOrNull()!);
    }
    return Success(entriesNum.getOrThrow() == 0);
  }

  Future<Result<void>> clear() async {
    try {
      await db.delete(db.notificationTranslations).go();
      return Success("ok");
    } catch (e) {
      return Failure(Exception("Error clearing entries: $e"));
    }
  }
}
