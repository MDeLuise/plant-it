import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 30).unique()();
  TextColumn get description => text().withLength(max: 50).nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();

  // factory Events.fromMap(Map<String, dynamic> map) {
  //   return Events(
  //     id: map['id'] as int?,
  //     name: map['name'] as String,
  //     description: map['description'] as String?,
  //     icon: map['icon'] as String?,
  //     color: map['color'] as String?,
  //     createdAt: map['createdAt'] as DateTime?,
  //   );
  // }

  // Map<String, Object?> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'description': description,
  //     'icon': icon,
  //     'color': color,
  //     'createdAt': createdAt,
  //   };
  // }
}

@DriftDatabase(tables: [Events])
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
    await into(events).insertOnConflictUpdate(EventsCompanion.insert(
      name: 'watering',
      icon: const Value('glass_water'),
    ));

    await into(events).insertOnConflictUpdate(EventsCompanion.insert(
      name: 'seeding',
      icon: const Value('bean'),
    ));
  }
}
