import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/reminder/reminder_occurrence_service.dart';

class ReminderNotificationService {
  final Environment env;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
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
    "{plantName} needs its {eventType}. Don't keep it waiting!",
    "{plantName} is calling for {eventType}. Time to save the day!",
    "{plantName} needs {eventType}. It's waiting for you!",
    "{plantName} is tired of waiting for {eventType}. Show it some TLC!",
    "{plantName} is overdue for {eventType}. Give it a boost!",
    "{plantName} is ready for {eventType}. Don't let it down!",
    "{plantName} needs its {eventType}. You're the hero it deserves!",
    "{plantName} misses its {eventType}. Time to make it happy again!"
  ];
  Timer? ongoingTimer;

  ReminderNotificationService(this.env);

  Future<void> initialize() async {
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

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showReminderNotification(Reminder reminderToNotify) async {
    final String plantName = await env.plantRepository
        .get(reminderToNotify.plant)
        .then((p) => p.name);
    final String eventTypeName = await env.eventTypeRepository
        .get(reminderToNotify.type)
        .then((t) => t.name);

    final int randomIndexTitle = Random().nextInt(notificationTitles.length);
    final int randomIndexBody = Random().nextInt(notificationBodies.length);
    final title = notificationTitles.elementAt(randomIndexTitle);
    final body = notificationBodies.elementAt(randomIndexBody)
        .replaceAll('{plantName}', plantName)
        .replaceAll('{eventType}', eventTypeName);

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Notification channel for reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _notificationsPlugin.show(
        reminderToNotify.id, title, body, notificationDetails);

    await env.reminderRepository.updateLastNotified(reminderToNotify);
  }

  Future<void> scheduleReminderCheck() async {
    if (ongoingTimer != null) {
      ongoingTimer!.cancel();
    }

    final notificationsEnabled = await _getNotificationsEnabled();
    if (!notificationsEnabled) {
      return;
    }

    final TimeOfDay notificationTime = await _getNotificationTime();
    final DateTime now = DateTime.now();
    DateTime targetTime = DateTime(now.year, now.month, now.day,
        notificationTime.hour, notificationTime.minute);

    if (targetTime.isBefore(now)) {
      targetTime = targetTime
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 10));
    }

    final durationUntilTarget = targetTime.difference(now);

    ongoingTimer = Timer(durationUntilTarget, () async {
      await _checkReminders();
      scheduleReminderCheck();
    });
  }

  Future<void> _checkReminders() async {
    final reminderOccurrence = ReminderOccurrenceService(env);
    final reminderIdsToNotify =
        await reminderOccurrence.getRemindersToNotifyToday();

    for (final Reminder reminder in reminderIdsToNotify) {
      await showReminderNotification(reminder);
    }
  }

  Future<bool> _getNotificationsEnabled() async {
    final notificationsEnabled = await env.userSettingRepository
        .getOrDefault('notificationsEnabled', 'false');
    return notificationsEnabled == 'true';
  }

  Future<TimeOfDay> _getNotificationTime() async {
    final notificationHour =
        await env.userSettingRepository.getOrDefault('notificationHour', '8');
    final notificationMinute =
        await env.userSettingRepository.getOrDefault('notificationMinute', '0');

    return TimeOfDay(
      hour: int.parse(notificationHour),
      minute: int.parse(notificationMinute),
    );
  }
}
