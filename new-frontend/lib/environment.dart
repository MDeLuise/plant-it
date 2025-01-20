import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/repositories/event_repository.dart';
import 'package:plant_it/repositories/event_type_repository.dart';
import 'package:plant_it/repositories/plant_repository.dart';

class Environment {
  final AppDatabase db;
  final Cache cache;
  final EventTypeRepository eventTypeRepository;
  final PlantRepository plantRepository;
  final EventRepository eventRepository;

  Environment(
    this.db,
    this.cache,
    this.eventTypeRepository,
    this.plantRepository,
    this.eventRepository,
  );
}
