import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plant_it/data/repository/plant_repository.dart';
import 'package:plant_it/database/database.dart';

import 'plant_repository_test.mocks.dart';

@GenerateMocks([
  AppDatabase,
  $PlantsTable,
  DeleteStatement,
  UpdateStatement,
  InsertStatement,
  SimpleSelectStatement,
  $AppDatabaseManager,
])
void main() {
  group('PlantRepository tests', () {
    late PlantRepository plantRepository;
    late MockAppDatabase appDatabase;
    late Mock$PlantsTable plantTable;

    setUp(() {
      appDatabase = MockAppDatabase();
      plantTable = Mock$PlantsTable();

      when(appDatabase.plants).thenReturn(plantTable);

      plantRepository = PlantRepository(db: appDatabase);
    });

    test('call DB delete if delete is called', () async {
      DeleteStatement<$PlantsTable, Plant> deleteStatement =
          MockDeleteStatement();

      when(appDatabase.delete(any)).thenReturn(deleteStatement);
      when(deleteStatement.go()).thenAnswer((_) async => Future.value(42));
      when(plantTable.asDslTable).thenReturn(plantTable);

      await plantRepository.delete(42);

      verify(deleteStatement.go()).called(1);
    });

    test('call DB update if update is called', () async {
      UpdateStatement<$PlantsTable, Plant> updateStatement =
          MockUpdateStatement();
      PlantsCompanion updated = PlantsCompanion(id: Value(42));

      when(appDatabase.update(any)).thenReturn(updateStatement);
      when(updateStatement.replace(updated))
          .thenAnswer((_) async => Future.value(true));
      when(plantTable.asDslTable).thenReturn(plantTable);

      await plantRepository.update(updated);

      verify(updateStatement.replace(updated)).called(1);
    });

    test('call DB insert if insert is called', () async {
      InsertStatement<$PlantsTable, Plant> insertStatement =
          MockInsertStatement();
      PlantsCompanion toInsert = PlantsCompanion(id: Value(42));

      when(appDatabase.into(any)).thenReturn(insertStatement);
      when(insertStatement.insert(toInsert))
          .thenAnswer((_) async => Future.value(42));
      when(plantTable.asDslTable).thenReturn(plantTable);

      await plantRepository.insert(toInsert);

      verify(insertStatement.insert(toInsert)).called(1);
    });

    test('call DB get if get is called', () async {
      SimpleSelectStatement<$PlantsTable, Plant> selectStatement =
          MockSimpleSelectStatement();
      int toGet = 42;

      when(appDatabase.select(any)).thenReturn(selectStatement);
      when(plantTable.asDslTable).thenReturn(plantTable);

      await plantRepository.get(toGet);

      verify(selectStatement.getSingleOrNull()).called(1);
    });

    test('call DB get all if get all is called', () async {
      SimpleSelectStatement<$PlantsTable, Plant> selectStatement =
          MockSimpleSelectStatement();

      when(appDatabase.select(any)).thenReturn(selectStatement);
      when(plantTable.asDslTable).thenReturn(plantTable);

      await plantRepository.getAll();

      verify(selectStatement.get()).called(1);
    });
  });
}
