import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class EventTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 30).unique()();
  TextColumn get description => text().withLength(max: 50).nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class Plants extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 50).unique()();
  DateTimeColumn get startDate => dateTime().nullable()();
  TextColumn get note => text().withLength(max: 8500).nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => integer().references(EventTypes, #id)();
  IntColumn get plant => integer().references(Plants, #id)();
  TextColumn get note => text().withLength(max: 250).nullable()();
  DateTimeColumn get date => dateTime()();
}

@DriftDatabase(tables: [EventTypes, Plants, Events])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'plant_it_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }

  void initDummyData() async {
    await into(eventTypes).insertOnConflictUpdate(EventTypesCompanion.insert(
      name: 'watering',
      icon: const Value('glass_water'),
    ));

    await into(eventTypes).insertOnConflictUpdate(EventTypesCompanion.insert(
      name: 'seeding',
      icon: const Value('bean'),
    ));

    await into(plants).insertOnConflictUpdate(PlantsCompanion.insert(
      name: 'Sedum palmeri',
    ));

    await into(plants).insertOnConflictUpdate(PlantsCompanion.insert(
      name: 'Lithops',
    ));

    await into(plants).insertOnConflictUpdate(PlantsCompanion.insert(
      name: 'Monstera adasonii',
    ));

    await into(plants).insertOnConflictUpdate(PlantsCompanion.insert(
      name: 'Kalanchoe jetpack',
    ));
  }
}
