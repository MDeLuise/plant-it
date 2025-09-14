import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/config/dependencies.dart';
import 'package:plant_it/data/service/notification_service.dart';
import 'package:plant_it/data/service/scheduling_service.dart';
import 'package:plant_it/data/service/search/cache/app_cache.dart';
import 'package:plant_it/data/service/search/cache/app_cache_pref.dart';
import 'package:plant_it/data/service/search/species_searcher_facade.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/scroll_behaviour.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'routing/router.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == SchedulingService.taskName) {
        NotificationService notificationService = NotificationService.noParam();
        await notificationService.sendDueReminderNotifications();
      }
      if (task == AppCache.taskName) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        AppCachePref(pref: pref).clear();
      }
      return Future.value(true);
    } catch (error) {
      print('There is an error in the task $task: $error');
      return Future.error(error);
    }
  });
}

/// Default main method
void main() async {
  const String environment =
      String.fromEnvironment('ENV', defaultValue: 'prod');
  WidgetsFlutterBinding.ensureInitialized();

  await Workmanager().initialize(
    callbackDispatcher,
    //isInDebugMode: true,
  );

  await NotificationService.noParam().initialize();

  Duration cacheRetention = Duration(days: 7);
  Workmanager().registerPeriodicTask(
    "${AppCache.taskName}_${DateTime.timestamp()}",
    AppCache.taskName,
    initialDelay: cacheRetention,
    frequency: cacheRetention,
  );

  SharedPreferences pref = await SharedPreferences.getInstance();
  SingleChildWidget cacheProvider = Provider<AppCache>(
    create: (context) => AppCachePref(pref: pref),
  );
  SingleChildWidget searchProvider = Provider(
    create: (context) => SpeciesSearcherFacade(
      localSearcher: context.read(),
      floraCodexSearcher: context.read(),
      cache: context.read(),
    ),
  );

  Logger.root.level = "dev" == environment ? Level.ALL : Level.WARNING;

  runApp(
    MultiProvider(
      providers: [...providersLocal, cacheProvider, searchProvider],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // see https://github.com/material-foundation/flutter-packages/issues/574#issuecomment-2635023116
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp.router(
        localizationsDelegates: L.localizationsDelegates,
        supportedLocales: L.supportedLocales,
        scrollBehavior: AppCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: lightColorScheme?.primary ?? Colors.green,
            dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: darkColorScheme?.primary ?? Colors.green,
            dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        routerConfig: router(),
      );
    });
  }
}
