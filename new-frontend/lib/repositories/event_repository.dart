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

  Future<List<Event>> getByMonth(
      DateTime day, List<int>? plantIds, List<int>? eventTypeIds) async {
    final DateTime startOfMonth = DateTime(day.year, day.month, 1, 0, 0, 0);
    final DateTime endOfMonth = DateTime(day.year, day.month + 1, 1, 0, 0, 0)
        .subtract(const Duration(seconds: 1));

    final query = db.select(db.events)
      ..where((e) =>
          e.date.isBiggerOrEqualValue(startOfMonth) &
          e.date.isSmallerOrEqualValue(endOfMonth));

    if (plantIds != null && plantIds.isNotEmpty) {
      query.where((e) => e.plant.isIn(plantIds));
    }

    if (eventTypeIds != null && eventTypeIds.isNotEmpty) {
      query.where((e) => e.type.isIn(eventTypeIds));
    }

    query.orderBy([
      (e) => OrderingTerm(
            expression: e.date,
            mode: OrderingMode.desc,
          )
    ]);

    return query.get();
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

  Future<List<Event>> getLastOfAllTypesFiltered(
      List<int>? plantIds, List<int>? eventTypes) {
    return getFiltered(plantIds, null);
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

  Future<List<Event>> getLastEventsForPlant(int plantId) async {
    final events = db.events;

    // Subquery: Get the latest date for each event type for the given plantId
    final subquery = db.selectOnly(events)
      ..addColumns([events.type, events.date.max()])
      ..where(events.plant.equals(plantId))
      ..groupBy([events.type]);

    // Prepare the main query using the subquery result
    final results = await subquery.get();

    // Extract type-date pairs from the subquery result
    final latestTypeDatePairs = results.map((row) {
      final eventType = row.read(events.type)!;
      final latestDate = row.read(events.date.max())!;
      return {'eventType': eventType, 'latestDate': latestDate};
    }).toList();

    // Fetch the complete event details for each type-date pair
    final List<Event> latestEvents = [];
    for (final pair in latestTypeDatePairs) {
      final eventType = pair['eventType'] as int;
      final latestDate = pair['latestDate'] as DateTime;

      // Query the events table for the matching type and date
      final event = await (db.select(events)
            ..where((e) =>
                e.plant.equals(plantId) &
                e.type.equals(eventType) &
                e.date.equals(latestDate)))
          .getSingleOrNull();
      if (event != null) {
        latestEvents.add(event);
      }
    }

    return latestEvents;
  }
}
