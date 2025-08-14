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
import 'package:plant_it/ui/plant/view_models/plant_view_model.dart';
import 'package:plant_it/ui/plant/widgets/plant_screen.dart';
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
              );
              homeViewModel.load.execute();

              CalendarViewModel calendarViewModel;
              if (state.extra != null) {
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
                );
                calendarViewModel.load.execute();
              }

              return AppMainView(
                homeViewModel: homeViewModel,
                calendarViewModel: calendarViewModel,
                selectedView: selectedView,
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
                    plantId: id,
                  );
                  viewModel.load.execute();
                  return PlantScreen(viewModel: viewModel);
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
            );
            viewModel.load.execute();
            return CreateEventScreen(viewModel: viewModel);
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
            return EditEventScreen(viewModel: viewModel, eventId: id);
          },
        ),
      ],
    );
