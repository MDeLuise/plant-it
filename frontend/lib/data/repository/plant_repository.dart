import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/data/repository/crud_repository.dart';
import 'package:result_dart/result_dart.dart';

class PlantRepository extends CRUDRepository<Plant> {
  PlantRepository({required super.db});

  @override
  TableInfo<Table, Plant> get table => db.plants;

  Future<Result<int>> countBySpecies(int speciesId) async {
    int count = await db.managers.plants
        .filter((p) => p.species.id.equals(speciesId))
        .count();
    return count.toSuccess();
  }
}
