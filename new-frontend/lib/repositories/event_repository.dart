import 'package:drift/drift.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/repositories/base_repository.dart';

class EventRepository extends BaseRepository<Event> {
  final AppDatabase db;
  final Cache cache;

  EventRepository(this.db, this.cache);

  EventRepository.fromEnvironment(Environment env)
      : db = env.db,
        cache = env.cache;

  @override
  Future<List<Event>> getAll() async {
    return db.select(db.events).get();
  }

  @override
  Future<Event> get(int id) {
    return (db.select(db.events)..where((t) => t.id.equals(id)))
        .watchSingle()
        .first;
  }

  @override
  Future<int> insert(UpdateCompanion<Event> toInsert) {
    return db.into(db.events).insert(toInsert);
  }

  @override
  void delete(int id) {
    (db.delete(db.events)..where((e) => e.id.equals(id))).go();
  }

  @override
  Future<bool> update(Event updated) async {
    return db.update(db.events).replace(updated);
  }

  // Future<List<Event>> getByDay(DateTime day) async {
  //   final DateTime startOfDay = DateTime(day.year, day.month, day.day, 0, 0, 0);
  //   final DateTime endOfDay =
  //       DateTime(day.year, day.month, day.day, 23, 59, 59);

  //   return (db.select(db.events)
  //         ..where((e) =>
  //             e.date.isBiggerOrEqualValue(startOfDay) &
  //             e.date.isSmallerOrEqualValue(endOfDay))
  //         ..orderBy([
  //           (e) => OrderingTerm(
  //                 expression: e.date,
  //                 mode: OrderingMode.desc,
  //               )
  //         ]))
  //       .get();
  // }

  Future<List<Event>> getByMonth(DateTime day) async {
    final DateTime startOfMonth = DateTime(day.year, day.month, 1, 0, 0, 0);
    final DateTime endOfMonth = DateTime(day.year, day.month + 1, 1, 0, 0, 0)
        .subtract(const Duration(seconds: 1));

    return (db.select(db.events)
          ..where((e) =>
              e.date.isBiggerOrEqualValue(startOfMonth) &
              e.date.isSmallerOrEqualValue(endOfMonth))
          ..orderBy([
            (e) => OrderingTerm(
                  expression: e.date,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();
  }

  Future<List<Event>> getLast(int num) async {
    return (db.select(db.events)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.date,
                  mode: OrderingMode.desc,
                )
          ])
          ..limit(num))
        .get();
  }

  Future<int> count(List<int>? plantIds, List<int>? eventTypes) {
    if (plantIds == null && eventTypes != null) {
      return _countByEventTypes(eventTypes);
    } else if (plantIds != null && eventTypes == null) {
      return _countByPlants(plantIds);
    } else if (plantIds != null && eventTypes != null) {
      return _countByPlantsAndEventTypes(plantIds, eventTypes);
    } else {
      throw Exception(
          "At least one of plantIds and eventTypes must be not null");
    }
  }

  Future<int> _countByPlants(List<int> plantIds) {
    return _selectByPlants(plantIds).then((r) => r.length);
  }

  Future<int> _countByEventTypes(List<int> eventTypes) {
    return _selectByEventTypes(eventTypes).then((r) => r.length);
  }

  Future<int> _countByPlantsAndEventTypes(
      List<int> plantIds, List<int> eventTypes) {
    return _selectByPlantsAndEventTypes(plantIds, eventTypes)
        .then((r) => r.length);
  }

  Future<List<Event>> getFiltered(List<int>? plantIds, List<int>? eventTypes) {
    if (plantIds == null && eventTypes != null) {
      return _selectByEventTypes(eventTypes);
    } else if (plantIds != null && eventTypes == null) {
      return _selectByPlants(plantIds);
    } else if (plantIds != null && eventTypes != null) {
      return _selectByPlantsAndEventTypes(plantIds, eventTypes);
    } else {
      throw Exception(
          "At least one of plantIds and eventTypes must be not null");
    }
  }

  Future<Event?> getLastFiltered(List<int>? plantIds, List<int>? eventTypes) {
    return getFiltered(plantIds, eventTypes).then((r) {
      if (r.isEmpty) {
        return null;
      }
      return r.first;
    });
  }

  Future<List<Event>> _selectByPlants(List<int> plantIds) {
    return (db.select(db.events)
          ..where((e) => e.plant.isIn(plantIds))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.date,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();
  }

  Future<List<Event>> _selectByEventTypes(List<int> eventTypes) {
    return (db.select(db.events)
          ..where((e) => e.type.isIn(eventTypes))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.date,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();
  }

  Future<List<Event>> _selectByPlantsAndEventTypes(
      List<int> plantIds, List<int> eventTypes) {
    return (db.select(db.events)
          ..where((e) => Expression.and([
                e.plant.isIn(plantIds),
                e.type.isIn(eventTypes),
              ]))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.date,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();
  }
}
