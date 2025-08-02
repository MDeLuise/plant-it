import 'package:plant_it/data/repository/event_repository.dart';
import 'package:plant_it/data/repository/event_type_repository.dart';
import 'package:plant_it/data/repository/image_repository.dart';
import 'package:plant_it/data/repository/plant_repository.dart';
import 'package:plant_it/data/repository/reminder_occurrence_repository.dart';
import 'package:plant_it/data/repository/reminder_repository.dart';
import 'package:plant_it/data/repository/species_care_repository.dart';
import 'package:plant_it/data/repository/species_repository.dart';
import 'package:plant_it/data/repository/species_synonym_repository.dart';
import 'package:plant_it/data/repository/user_setting_repository.dart';
import 'package:plant_it/data/service/reminder_occurrence_service.dart';
import 'package:plant_it/database/database.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Shared providers for all configurations.
List<SingleChildWidget> _sharedProviders = [];

List<SingleChildWidget> get providersRemote {
  return [
    ..._sharedProviders,
  ];
}

List<SingleChildWidget> get providersLocal {
  return [
    Provider.value(value: AppDatabase()),
    Provider(
      create: (context) => EventRepository(db: context.read()),
    ),
    Provider(
      create: (context) => EventTypeRepository(db: context.read()),
    ),
    Provider(
      create: (context) => ImageRepository(db: context.read()),
    ),
    Provider(
      create: (context) => PlantRepository(db: context.read()),
    ),
    Provider(
      create: (context) => ReminderRepository(db: context.read()),
    ),
    Provider(
      create: (context) => SpeciesCareRepository(db: context.read()),
    ),
    Provider(
      create: (context) => SpeciesRepository(db: context.read()),
    ),
    Provider(
      create: (context) => SpeciesSynonymsRepository(db: context.read()),
    ),
    Provider(
      create: (context) => UserSettingRepository(db: context.read()),
    ),
    Provider(
      create: (context) => ReminderOccurrenceService(
        reminderRepository: context.read(),
        eventRepository: context.read(),
        eventTypeRepository: context.read(),
        plantRepository: context.read(),
      ),
    ),
    Provider(
      create: (context) =>
          ReminderOccurrenceRepository(service: context.read()),
    ),
    ..._sharedProviders,
  ];
}
