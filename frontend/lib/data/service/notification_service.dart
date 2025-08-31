import 'dart:math';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/event_repository.dart';
import 'package:plant_it/data/repository/event_type_repository.dart';
import 'package:plant_it/data/repository/plant_repository.dart';
import 'package:plant_it/data/repository/reminder_repository.dart';
import 'package:plant_it/data/repository/user_setting_repository.dart';
import 'package:plant_it/data/service/reminder_occurrence_service.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/user_settings_keys.dart';
import 'package:result_dart/result_dart.dart';

class NotificationService {
  final List<String> notificationEmoji = [
    "🌺",
    "🍀",
    "🌷",
    "🌻",
    "🌼",
    "🪴",
    "🌹",
    "🌸",
    "🌿",
    "🌱",
    "🌵",
    "🪻"
  ];
  final List<String> notificationTitles = [
    "Oops, You Did It Again!",
    "Plant SOS!",
    "Time to be a Plant Whisperer!",
    "Not Today, Plant!",
    "Plant Caffeine Required!",
    "Leaf It Up to You!",
    "Call the Green Squad!",
    "You've Been 'Leafing' It Alone"
  ];
  final List<String> notificationBodies = [
    "{emoji} {plantName} needs its {eventType}. Don't keep it waiting!",
    "{emoji} {plantName} is calling for {eventType}. Time to save the day!",
    "{emoji} {plantName} needs {eventType}. It's waiting for you!",
    "{emoji} {plantName} is tired of waiting for {eventType}. Show it some TLC!",
    "{emoji} {plantName} is overdue for {eventType}. Give it a boost!",
    "{emoji} {plantName} is ready for {eventType}. Don't let it down!",
    "{emoji} {plantName} needs its {eventType}. You're the hero it deserves!",
    "{emoji} {plantName} misses its {eventType}. Time to make it happy again!"
  ];
  final AndroidNotificationDetails notificationDetails =
      AndroidNotificationDetails(
    'reminder_channel',
    'Reminders',
    channelDescription: 'Notification channel for reminders',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
    icon: 'ic_notification',
    color: Color.fromARGB(255, 58, 133, 60),
  );
  final _log = Logger('NotificationService');
  late final ReminderOccurrenceService _reminderOccurrenceService;
  late final EventTypeRepository _eventTypeRepository;
  late final PlantRepository _plantRepository;
  late final UserSettingRepository _userSettingRepository;

  NotificationService({
    required ReminderOccurrenceService reminderOccurrenceService,
    required EventTypeRepository eventTypeRepository,
    required PlantRepository plantRepository,
    required UserSettingRepository userSettingRepository,
  })  : _reminderOccurrenceService = reminderOccurrenceService,
        _eventTypeRepository = eventTypeRepository,
        _plantRepository = plantRepository,
        _userSettingRepository = userSettingRepository;

  /// To use only in callbackDispatcher
  NotificationService.noParam() {
    AppDatabase db = AppDatabase();
    _reminderOccurrenceService = ReminderOccurrenceService(
        reminderRepository: ReminderRepository(db: db),
        eventRepository: EventRepository(db: db),
        eventTypeRepository: EventTypeRepository(db: db),
        plantRepository: PlantRepository(db: db));
    _eventTypeRepository = EventTypeRepository(db: db);
    _plantRepository = PlantRepository(db: db);
  }

  Future<bool?> initialize() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    return FlutterLocalNotificationsPlugin().initialize(initializationSettings);
  }

  void requireNotificationPermission() {
    FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
  }

  Future<void> sendDueReminderNotifications() async {
    Result<List<Reminder>> reminders =
        await _reminderOccurrenceService.getRemindersToNotify();
    if (reminders.isError()) {
      _log.severe(reminders.exceptionOrNull().toString());
      return;
    }
    for (Reminder r in reminders.getOrThrow()) {
      await _notifyReminder(r);
    }
  }

  Future<void> _notifyReminder(Reminder reminder) async {
    Result<Plant> plant = await _plantRepository.get(reminder.plant);
    if (plant.isError()) {
      _log.severe(plant.exceptionOrNull().toString());
      return;
    }
    String plantName = plant.getOrThrow().name;

    Result<EventType> eventType = await _eventTypeRepository.get(reminder.type);
    if (eventType.isError()) {
      _log.severe(eventType.exceptionOrNull().toString());
      return;
    }
    String eventTypeName = eventType.getOrThrow().name;

    int randomIndexEmoji = Random().nextInt(notificationEmoji.length);
    int randomIndexTitle = Random().nextInt(notificationTitles.length);
    int randomIndexBody = Random().nextInt(notificationBodies.length);
    String emoji = notificationEmoji.elementAt(randomIndexEmoji);
    String title = notificationTitles.elementAt(randomIndexTitle);
    String body = notificationBodies
        .elementAt(randomIndexBody)
        .replaceAll('{emoji}', emoji)
        .replaceAll('{plantName}', plantName)
        .replaceAll('{eventType}', eventTypeName);

    await FlutterLocalNotificationsPlugin().show(Random().nextInt(1000), title,
        body, NotificationDetails(android: notificationDetails));

    await _reminderOccurrenceService.updateLastNotified(reminder);

    await _updatedNextNotificationTimeInDB();
  }

  Future<void> _updatedNextNotificationTimeInDB() async {
    List<UserSettingsKeys> dayKeysDateTime = [
      UserSettingsKeys.notificationDateTimeMonday,
      UserSettingsKeys.notificationDateTimeTuesday,
      UserSettingsKeys.notificationDateTimeWednesday,
      UserSettingsKeys.notificationDateTimeThursday,
      UserSettingsKeys.notificationDateTimeFriday,
      UserSettingsKeys.notificationDateTimeSaturday,
      UserSettingsKeys.notificationDateTimeSunday,
    ];

    DateTime now = DateTime.now();
    String keyToSave = dayKeysDateTime[now.weekday - 1].key;
    String valueToSave = DateTime.now().add(Duration(days: 1)).toString();
    await _userSettingRepository.put(keyToSave, valueToSave);
  }
}
