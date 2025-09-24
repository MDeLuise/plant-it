import 'package:go_router/go_router.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/calendar/widgets/filter/activity_filter.dart';
import 'package:plant_it/ui/event/view_models/edit_event_viewmodel.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';
import 'package:plant_it/ui/event/widgets/edit/edit_event_screen.dart';
import 'package:plant_it/ui/event/widgets/create/event_screen.dart';
import 'package:plant_it/ui/home/view_models/home_viewmodel.dart';
import 'package:plant_it/ui/main/app_main_view.dart';
import 'package:plant_it/ui/plant/view_models/add_plant_viewmodel.dart';
import 'package:plant_it/ui/plant/view_models/edit_plant_viewmodel.dart';
import 'package:plant_it/ui/plant/view_models/plant_view_model.dart';
import 'package:plant_it/ui/plant/widgets/create/add_plant_screen.dart';
import 'package:plant_it/ui/plant/widgets/edit/edit_plant_screen.dart';
import 'package:plant_it/ui/plant/widgets/plant_screen.dart';
import 'package:plant_it/ui/search/view_models/search_viewmodel.dart';
import 'package:plant_it/ui/settings/widgets/database_and_cache_screen.dart';
import 'package:plant_it/ui/settings/view_models/event_type/add_event_type_viewmodel.dart';
import 'package:plant_it/ui/settings/view_models/event_type/edit_event_type_viewmodel.dart';
import 'package:plant_it/ui/settings/view_models/event_type/event_type_viewmodel.dart';
import 'package:plant_it/ui/settings/view_models/reminder/add_reminder_viewmodel.dart';
import 'package:plant_it/ui/settings/view_models/reminder/edit_reminder_viewmodel.dart';
import 'package:plant_it/ui/settings/view_models/reminder/reminder_viewmodel.dart';
import 'package:plant_it/ui/settings/view_models/settings_viewmodel.dart';
import 'package:plant_it/ui/settings/widgets/data_sources_screen.dart';
import 'package:plant_it/ui/settings/widgets/event_type/create/add_event_type_screen.dart';
import 'package:plant_it/ui/settings/widgets/event_type/edit/edit_event_type_screen.dart';
import 'package:plant_it/ui/settings/widgets/event_type/event_type_screen.dart';
import 'package:plant_it/ui/settings/widgets/info_screen.dart';
import 'package:plant_it/ui/settings/widgets/notifications_screen.dart';
import 'package:plant_it/ui/settings/widgets/reminder/create/add_reminder_screen.dart';
import 'package:plant_it/ui/settings/widgets/reminder/edit/edit_reminder_screen.dart';
import 'package:plant_it/ui/settings/widgets/reminder/reminder_screen.dart';
import 'package:plant_it/ui/species/view_models/add_species_viewmodel.dart';
import 'package:plant_it/ui/species/view_models/edit_species_viewmodel.dart';
import 'package:plant_it/ui/species/view_models/view_species_viewmodel.dart';
import 'package:plant_it/ui/species/widgets/create/add_species_screen.dart';
import 'package:plant_it/ui/species/widgets/edit/edit_species_screen.dart';
import 'package:plant_it/ui/species/widgets/view/view_species_screen.dart';
import 'package:provider/provider.dart';

GoRouter router() => GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
            path: Routes.home,
            builder: (context, state) {
              int selectedView = 0;

              HomeViewModel homeViewModel = HomeViewModel(
                plantRepository: context.read(),
                reminderOccurrenceRepository: context.read(),
                imageRepository: context.read(),
                eventRepository: context.read(),
                streamController: context.read(),
              );
              homeViewModel.load.execute();

              if (state.extra != null && state.extra is int) {
                selectedView = state.extra as int;
              }
              CalendarViewModel calendarViewModel;
              if (state.extra != null && state.extra is CalendarViewModel) {
                calendarViewModel = state.extra as CalendarViewModel;
                selectedView = 1;
                calendarViewModel.filter.execute();
              } else {
                calendarViewModel = CalendarViewModel(
                  eventRepository: context.read(),
                  plantRepository: context.read(),
                  eventTypeRepository: context.read(),
                  speciesRepository: context.read(),
                  reminderOccurrenceService: context.read(),
                  streamController: context.read(),
                );
                calendarViewModel.load.execute();
              }

              SearchViewModel searchViewModel = SearchViewModel(
                speciesSearcherFacade: context.read(),
                imageRepository: context.read(),
              );
              searchViewModel.search.execute(Query(
                term: "",
                offset: 0,
                limit: 10,
              ));

              SettingsViewModel settingsViewModel = SettingsViewModel(
                userSettingRepository: context.read(),
                schedulingService: context.read(),
                notificationService: context.read(),
                reminderRepository: context.read(),
                appCache: context.read(),
                notificationsLangRepository: context.read(),
                sharedPreferences: context.read(),
              );
              settingsViewModel.load.execute();

              return AppMainView(
                homeViewModel: homeViewModel,
                calendarViewModel: calendarViewModel,
                searchViewModel: searchViewModel,
                settingsViewModel: settingsViewModel,
                selectedView: selectedView,
                streamController: context.read(),
                pref: context.read(),
                notificationsLangRepository: context.read(),
              );
            },
            routes: [
              GoRoute(
                path: '${Routes.plant}/:id',
                builder: (context, state) {
                  int id = int.parse(state.pathParameters['id']!);
                  PlantViewModel viewModel = PlantViewModel(
                    plantRepository: context.read(),
                    speciesRepository: context.read(),
                    speciesCareRepository: context.read(),
                    imageRepository: context.read(),
                    eventRepository: context.read(),
                    eventTypeRepository: context.read(),
                    reminderRepository: context.read(),
                    reminderOccurrenceRepository: context.read(),
                  );
                  viewModel.load.execute(id);
                  return PlantScreen(
                    viewModel: viewModel,
                    streamController: context.read(),
                  );
                },
              ),
              GoRoute(
                path: Routes.plant,
                builder: (context, state) {
                  Map<String, Object?> input =
                      state.extra as Map<String, Object?>;

                  Map<String, Object?>? toCreate;
                  if (input.containsKey('toCreate') &&
                      input['toCreate'] != null) {
                    toCreate = input['toCreate'] as Map<String, Object?>;
                  }

                  AddPlantViewModel viewModel = AddPlantViewModel(
                    plantRepository: context.read(),
                    speciesToCreate: toCreate,
                    speciesRepository: context.read(),
                    speciesCareRepository: context.read(),
                    speciesSynonymsRepository: context.read(),
                    imageRepository: context.read(),
                    appCache: context.read(),
                  );
                  viewModel.load.execute(input);
                  return AddPlantScreen(
                    viewModel: viewModel,
                    streamController: context.read(),
                  );
                },
              ),
              GoRoute(
                path: '${Routes.plant}/:id/_edit',
                builder: (context, state) {
                  int id = int.parse(state.pathParameters['id']!);
                  EditPlantViewModel viewModel = EditPlantViewModel(
                    plantRepository: context.read(),
                  );
                  viewModel.load.execute(id);
                  return EditPlantScreen(
                    viewModel: viewModel,
                    streamController: context.read(),
                  );
                },
              ),
              GoRoute(
                path: Routes.settingsNotifications,
                builder: (context, state) {
                  SettingsViewModel viewModel =
                      state.extra as SettingsViewModel;
                  return NotificationsScreen(viewModel: viewModel);
                },
              ),
              GoRoute(
                path: Routes.settingsInfo,
                builder: (context, state) {
                  return InfoScreen();
                },
              ),
              GoRoute(
                path: Routes.settingsDataSources,
                builder: (context, state) {
                  SettingsViewModel viewModel;
                  if (state.extra != null) {
                    viewModel = state.extra as SettingsViewModel;
                  } else {
                    viewModel = SettingsViewModel(
                      userSettingRepository: context.read(),
                      reminderRepository: context.read(),
                      schedulingService: context.read(),
                      notificationService: context.read(),
                      appCache: context.read(),
                      notificationsLangRepository: context.read(),
                      sharedPreferences: context.read(),
                    );
                    viewModel.load.execute();
                  }
                  return DataSourcesScreen(viewModel: viewModel);
                },
              ),
              GoRoute(
                path: Routes.settingsFloraCodex,
                builder: (context, state) {
                  SettingsViewModel viewModel =
                      state.extra as SettingsViewModel;
                  return FloraCodexScreen(
                    workmanager: context.read(),
                    viewModel: viewModel,
                  );
                },
              ),
              GoRoute(
                path: Routes.settingsDatabaseAndCache,
                builder: (context, state) {
                  SettingsViewModel viewModel =
                      state.extra as SettingsViewModel;
                  return DatabaseAndCacheScreen(viewModel: viewModel);
                },
              ),
              GoRoute(
                path: Routes.eventTypes,
                builder: (context, state) {
                  EventTypeViewModel viewModel = EventTypeViewModel(
                    eventTypeRepository: context.read(),
                  );
                  viewModel.load.execute();
                  return EventTypeScreen(viewModel: viewModel);
                },
              ),
              GoRoute(
                path: Routes.eventType,
                builder: (context, state) {
                  AddEventTypeViewModel viewModel = AddEventTypeViewModel(
                    eventTypeRepository: context.read(),
                  );
                  return AddEventTypeScreen(viewModel: viewModel);
                },
              ),
              GoRoute(
                path: '${Routes.eventType}/:id',
                builder: (context, state) {
                  int id = int.parse(state.pathParameters['id']!);
                  EditEventTypeViewModel viewModel = EditEventTypeViewModel(
                    eventTypeRepository: context.read(),
                  );
                  viewModel.load.execute(id);
                  return EditEventTypeScreen(viewModel: viewModel);
                },
              ),
              GoRoute(
                path: Routes.reminders,
                builder: (context, state) {
                  ReminderViewModel viewModel = ReminderViewModel(
                    eventTypeRepository: context.read(),
                    reminderRepository: context.read(),
                    plantRepository: context.read(),
                    streamController: context.read(),
                  );
                  viewModel.load.execute();
                  return ReminderScreen(viewModel: viewModel);
                },
              ),
              GoRoute(
                path: Routes.reminder,
                builder: (context, state) {
                  AddReminderViewModel viewModel = AddReminderViewModel(
                    reminderRepository: context.read(),
                    eventTypeRepository: context.read(),
                    plantRepository: context.read(),
                    speciesRepository: context.read(),
                    streamController: context.read(),
                  );
                  viewModel.load.execute();
                  return AddReminderScreen(viewModel: viewModel);
                },
              ),
              GoRoute(
                path: '${Routes.reminder}/:id',
                builder: (context, state) {
                  int id = int.parse(state.pathParameters['id']!);
                  EditReminderViewModel viewModel = EditReminderViewModel(
                    reminderRepository: context.read(),
                    eventTypeRepository: context.read(),
                    plantRepository: context.read(),
                    speciesRepository: context.read(),
                    streamController: context.read(),
                  );
                  viewModel.load.execute(id);
                  return EditReminderScreen(viewModel: viewModel);
                },
              ),
            ]),
        GoRoute(
          path: Routes.event,
          builder: (context, state) {
            CreateEventFormViewModel viewModel = CreateEventFormViewModel(
              eventRepository: context.read(),
              plantRepository: context.read(),
              eventTypeRepository: context.read(),
              speciesRepository: context.read(),
              streamController: context.read(),
            );
            viewModel.load.execute();
            return CreateEventScreen(
              viewModel: viewModel,
            );
          },
        ),
        GoRoute(
          path: Routes.activityFilter,
          builder: (context, state) {
            CalendarViewModel viewModel = state.extra as CalendarViewModel;
            return ActivityFilter(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: '${Routes.event}/:id',
          builder: (context, state) {
            int id = int.parse(state.pathParameters['id']!);
            EditEventFormViewModel viewModel = EditEventFormViewModel(
              eventRepository: context.read(),
              plantRepository: context.read(),
              eventTypeRepository: context.read(),
              speciesRepository: context.read(),
            );
            viewModel.load.execute(id);
            return EditEventScreen(
              viewModel: viewModel,
              eventId: id,
            );
          },
        ),
        GoRoute(
          path: Routes.species,
          builder: (context, state) {
            String? searchedTerm;
            if (state.extra != null) {
              searchedTerm = state.extra as String;
            }

            AddSpeciesViewModel viewModel = AddSpeciesViewModel(
              speciesRepository: context.read(),
              speciesCareRepository: context.read(),
              speciesSynonymsRepository: context.read(),
              imageRepository: context.read(),
              appCache: context.read(),
              streamController: context.read(),
            );
            return AddSpeciesScreen(
              viewModel: viewModel,
              searchedTerm: searchedTerm,
            );
          },
        ),
        GoRoute(
          path: Routes.speciesWithIdOrExternal,
          builder: (context, state) {
            dynamic idOrExternal;
            if (state.extra != null) {
              idOrExternal = state.extra;
            }

            ViewSpeciesViewModel viewModel = ViewSpeciesViewModel(
              speciesRepository: context.read(),
              speciesCareRepository: context.read(),
              speciesSynonymsRepository: context.read(),
              imageRepository: context.read(),
              appCache: context.read(),
              speciesSearcherFacade: context.read(),
            );
            viewModel.load.execute(idOrExternal);

            return ViewSpeciesScreen(
              viewModel: viewModel,
              streamController: context.read(),
            );
          },
        ),
        GoRoute(
          path: '${Routes.species}/:id',
          builder: (context, state) {
            int id = int.parse(state.pathParameters['id']!);
            EditSpeciesViewModel viewModel = EditSpeciesViewModel(
              speciesRepository: context.read(),
              speciesCareRepository: context.read(),
              speciesSynonymsRepository: context.read(),
              imageRepository: context.read(),
              appCache: context.read(),
              streamController: context.read(),
            );
            viewModel.load.execute(id);

            return EditSpeciesScreen(viewModel: viewModel);
          },
        ),
      ],
    );
