import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/notification/reminder_notification_service.dart';
import 'package:plant_it/repositories/event_repository.dart';
import 'package:plant_it/repositories/event_type_repository.dart';
import 'package:plant_it/repositories/image_repository.dart';
import 'package:plant_it/repositories/plant_repository.dart';
import 'package:plant_it/repositories/reminder_repository.dart';
import 'package:plant_it/repositories/species_care_repository.dart';
import 'package:plant_it/repositories/species_repository.dart';
import 'package:plant_it/repositories/species_synonym_repository.dart';
import 'package:plant_it/repositories/user_setting_repository.dart';

class Environment {
  final AppDatabase db;
  final Cache cache;
  final EventTypeRepository eventTypeRepository;
  final PlantRepository plantRepository;
  final EventRepository eventRepository;
  final ReminderRepository reminderRepository;
  final ImageRepository imageRepository;
  final UserSettingRepository userSettingRepository;
  final SpeciesRepository speciesRepository;
  final SpeciesSynonymsRepository speciesSynonymsRepository;
  final SpeciesCareRepository speciesCareRepository;
  late ReminderNotificationService reminderNotificationService;

  Environment(
    this.db,
    this.cache,
    this.eventTypeRepository,
    this.plantRepository,
    this.eventRepository,
    this.reminderRepository,
    this.imageRepository,
    this.userSettingRepository,
    this.speciesRepository,
    this.speciesSynonymsRepository,
    this.speciesCareRepository,
  );
}
