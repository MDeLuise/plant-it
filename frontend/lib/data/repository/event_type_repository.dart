import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/data/repository/crud_repository.dart';

class EventTypeRepository extends CRUDRepository<EventType> {
  EventTypeRepository({required super.db});

  @override
  TableInfo<Table, EventType> get table => db.eventTypes;
}
