import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/data/repository/crud_repository.dart';
import 'package:result_dart/result_dart.dart';

class EventRepository extends CRUDRepository<Event> {
  EventRepository({required super.db});

  @override
  TableInfo<Table, Event> get table => db.events;

  Future<Result<List<Event>>> getByMonth(
      DateTime day, List<int>? plantIds, List<int>? eventTypeIds) async {
    DateTime startOfMonth = DateTime(day.year, day.month, 1, 0, 0, 0);
    DateTime endOfMonth = DateTime(day.year, day.month + 1, 1, 0, 0, 0)
        .subtract(const Duration(seconds: 1));

    var query = db.select(db.events)
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

    return (await query.get()).toSuccess();
  }

  Future<Result<List<Event>>> getLast(int num) async {
    List<Event> lastEvent = await (db.select(db.events)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.date,
                  mode: OrderingMode.desc,
                )
          ])
          ..limit(num))
        .get();
    return lastEvent.toSuccess();
  }

  Future<Result<List<Event>>> getFiltered(
      List<int>? plantIds, List<int>? eventTypes) {
    if (plantIds == null && eventTypes != null) {
      return _selectByEventTypes(eventTypes);
    } else if (plantIds != null && eventTypes == null) {
      return _selectByPlants(plantIds);
    } else if (plantIds != null && eventTypes != null) {
      return _selectByPlantsAndEventTypes(plantIds, eventTypes);
    } else {
      throw Failure(Exception(
          "At least one of plantIds and eventTypes must be not null"));
    }
  }

  Future<Result<Event>?> getLastFiltered(
      List<int>? plantIds, List<int>? eventTypes) {
    return getFiltered(plantIds, eventTypes).then((r) {
      if (r.isError()) {
        return r.exceptionOrNull()!.toFailure();
      }
      if (r.getOrThrow().isEmpty) {
        return null;
      }
      return r.getOrThrow().first.toSuccess();
    });
  }

  Future<Result<List<Event>>> getLastOfAllTypesFiltered(
      List<int>? plantIds, List<int>? eventTypes) {
    return getFiltered(plantIds, null);
  }

  Future<Result<List<Event>>> _selectByPlants(List<int> plantIds) async {
    List<Event> events = await (db.select(db.events)
          ..where((e) => e.plant.isIn(plantIds))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.date,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();
    return events.toSuccess();
  }

  Future<Result<List<Event>>> _selectByEventTypes(List<int> eventTypes) async {
    List<Event> events = await (db.select(db.events)
          ..where((e) => e.type.isIn(eventTypes))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.date,
                  mode: OrderingMode.desc,
                )
          ]))
        .get();
    return events.toSuccess();
  }

  Future<Result<List<Event>>> _selectByPlantsAndEventTypes(
      List<int> plantIds, List<int> eventTypes) async {
    List<Event> events = await (db.select(db.events)
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
    return events.toSuccess();
  }

  Future<Result<List<Event>>> getLastEventsForPlant(int plantId) async {
    final events = db.events;

    // Subquery: Get the latest date for each event type for the given plantId
    final subquery = db.selectOnly(events)
      ..addColumns([events.type, events.date.max()])
      ..where(events.plant.equals(plantId))
      ..groupBy([events.type]);

    // Prepare the main query using the subquery result
    List<TypedResult> results;
    try {
      results = await subquery.get();
    } catch (e) {
      return Failure(Exception(e.toString()));
    }

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

    return latestEvents.toSuccess();
  }
}
