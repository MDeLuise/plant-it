import 'package:go_router/go_router.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/calendar/widgets/calendar_screen.dart';
import 'package:plant_it/ui/calendar/widgets/filter/activity_filter.dart';
import 'package:plant_it/ui/event/view_models/edit_event_viewmodel.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';
import 'package:plant_it/ui/event/widgets/edit/edit_event_screen.dart';
import 'package:plant_it/ui/event/widgets/view/event_screen.dart';
import 'package:plant_it/ui/home/view_models/home_viewmodel.dart';
import 'package:plant_it/ui/home/widgets/home_screen.dart';
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
              HomeViewModel viewModel = HomeViewModel(
                plantRepository: context.read(),
                reminderOccurrenceRepository: context.read(),
                imageRepository: context.read(),
              );
              viewModel.load.execute();
              return HomeScreen(viewModel: viewModel);
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
            EventFormViewModel viewModel = EventFormViewModel(
              eventRepository: context.read(),
              plantRepository: context.read(),
              eventTypeRepository: context.read(),
              speciesRepository: context.read(),
            );
            viewModel.load.execute();
            return EventScreen(viewModel: viewModel);
          },
        ),
        GoRoute(
          path: Routes.calendar,
          builder: (context, state) {
            CalendarViewModel viewModel;
            if (state.extra != null) {
              viewModel = state.extra as CalendarViewModel;
            } else {
              viewModel = CalendarViewModel(
                eventRepository: context.read(),
                plantRepository: context.read(),
                eventTypeRepository: context.read(),
                speciesRepository: context.read(),
                reminderOccurrenceService: context.read(),
              );
              viewModel.load.execute();
            }
            return CalendarScreen(viewModel: viewModel);
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
