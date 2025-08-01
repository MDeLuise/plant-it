import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/data/repository/crud_repository.dart';
import 'package:result_dart/result_dart.dart';

class ReminderRepository extends CRUDRepository<Reminder> {
  ReminderRepository({required super.db});

  @override
  TableInfo<Table, Reminder> get table => db.reminders;

  Future<Result<bool>> updateLastNotified(Reminder reminder) {
    return update(reminder
        .copyWith(lastNotified: Value.absentIfNull(DateTime.now()))
        .toCompanion(false));
  }

  Future<Result<List<Reminder>>> getFiltered(
      List<int>? plantIds, List<int>? eventTypeIds) async {
    SimpleSelectStatement<$RemindersTable, Reminder> query =
        db.select(db.reminders);

    if (plantIds != null && plantIds.isNotEmpty) {
      query.where((reminder) => reminder.plant.isIn(plantIds));
    }

    if (eventTypeIds != null && eventTypeIds.isNotEmpty) {
      query.where((reminder) => reminder.type.isIn(eventTypeIds));
    }

    return (await query.get()).toSuccess();
  }
}
