import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:result_dart/result_dart.dart';

abstract class CRUDRepository<T extends DataClass> {
  final AppDatabase db;

  CRUDRepository({required this.db});

  TableInfo<Table, T> get table;

  Future<Result<List<T>>> getAll() async {
    try {
      List<T> rows = await db.select(table).get();
      return Success(rows);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<T>> get(int id) async {
    try {
      final SimpleSelectStatement<Table, T> query = db.select(table)
        ..where((t) => (t as dynamic).id.equals(id));
      final T? result = await query.getSingleOrNull();
      if (result == null) {
        return Failure(Exception('No entry found with id $id'));
      }
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<int>> insert(UpdateCompanion<T> toInsert) async {
    try {
      int result = await db.into(table).insert(toInsert);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void>> delete(int id) async {
    try {
      await (db.delete(table)..where((t) => (t as dynamic).id.equals(id))).go();
      return Success("ok");
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<bool>> update(UpdateCompanion<T> updated) async {
    try {
      final bool result = await db.update(table).replace(updated);
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  Future<Result<void>> insertAll(List<UpdateCompanion<T>> toInsert) async {
    try {
      await db.batch((batch) {
        batch.insertAll(table, toInsert);
      });
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
    return Success("ok");
  }
}
