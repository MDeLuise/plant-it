import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plant_it/events/add_event.dart';
import 'package:plant_it/bottombar.dart';
import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/activity/events_page.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/homepage/homepage.dart';
import 'package:plant_it/more/more_page.dart';
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
import 'package:plant_it/search/search_page.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:plant_it/trefle_import/background_import.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeNotifications();
  final env = _createEnvironment();
  env.db.initDummyData();

  await Workmanager().initialize(
    _callbackDispatcher,
    //isInDebugMode: true,
  );

  runApp(MyApp(env));
}

@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "import_species_task") {
      await importSpecies(_createEnvironment(), inputData);
    }
    return Future.value(true);
  });
}

Environment _createEnvironment() {
  final db = AppDatabase();
  const String cacheKey = "customCacheManager";
  final cache = Cache(
      cacheManager: CacheManager(
    Config(
      cacheKey,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: cacheKey),
      fileSystem: IOFileSystem(cacheKey),
      fileService: HttpFileService(),
    ),
  ));
  final Environment result = Environment(
    db,
    cache,
    EventTypeRepository(db, cache),
    PlantRepository(db, cache),
    EventRepository(db, cache),
    ReminderRepository(db, cache),
    ImageRepository(db, cache),
    UserSettingRepository(db, cache),
    SpeciesRepository(db, cache),
    SpeciesSynonymsRepository(db, cache),
    SpeciesCareRepository(db, cache),
  );

  result.reminderNotificationService = ReminderNotificationService(result);

  return result;
}

Future<void> _initializeNotifications() {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  return flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  final Environment env;

  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.green);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.green, brightness: Brightness.dark);

  const MyApp(this.env, {super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
        home: MyHomePage(env),
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  final Environment env;

  const MyHomePage(this.env, {super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;
  final List<GlobalKey> _pageKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  void _showAddEventScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventScreen(widget.env),
      ),
    ).then((added) {
      if (added != null && added == true) {
        widget.env.cache.removeAll();
        setState(() {
          _pageKeys[_currentPageIndex] = GlobalKey();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _currentPageIndex < 3
          ? FloatingActionButton(
              onPressed: _showAddEventScreen,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: Bottombar(
        callback: (i) => setState(() {
          _currentPageIndex = i;
        }),
      ),
      body: <Widget>[
        Homepage(key: _pageKeys[0], widget.env),
        EventsPage(key: _pageKeys[1], widget.env),
        SearchPage(key: _pageKeys[1], widget.env),
        MorePage(widget.env, key: const Key('More')),
      ][_currentPageIndex],
    );
  }
}
