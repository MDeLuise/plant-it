import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/repositories/event_repository.dart';

class Environment {
  final AppDatabase db;
  final Cache cache;
  final EventRepository eventRepository;

  Environment(
    this.db,
    this.cache,
    this.eventRepository,
  );
}
