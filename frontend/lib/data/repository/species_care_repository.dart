import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/data/repository/crud_repository.dart';
import 'package:result_dart/result_dart.dart';

class SpeciesCareRepository extends CRUDRepository<SpeciesCareData> {
  SpeciesCareRepository({required super.db});

  @override
  Future<Result<SpeciesCareData>> get(int id) async {
    try {
      final SimpleSelectStatement<Table, SpeciesCareData> query =
          db.select(table)..where((t) => (t as dynamic).species.equals(id));
      final SpeciesCareData? result = await query.getSingleOrNull();
      if (result == null) {
        return Failure(Exception('No entry found with id $id'));
      }
      return Success(result);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> delete(int id) async {
    try {
      await (db.delete(table)..where((t) => (t as dynamic).species.equals(id))).go();
      return Success("ok");
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  // TODO override others

  @override
  TableInfo<Table, SpeciesCareData> get table => db.speciesCare;
}
