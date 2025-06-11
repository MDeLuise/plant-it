import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/reminder/reminder_occurrence_service.dart';
import 'package:workmanager/workmanager.dart';

class ReminderNotificationService {
  final Environment env;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
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
  final String reminderUniqueName = "daily-reminder-task-id";
  final Workmanager workmanager = Workmanager();

  ReminderNotificationService(this.env);

  Future<void> _showReminderNotification(Reminder reminderToNotify) async {
    final String plantName = await env.plantRepository
        .get(reminderToNotify.plant)
        .then((p) => p.name);
    final String eventTypeName = await env.eventTypeRepository
        .get(reminderToNotify.type)
        .then((t) => t.name);

    final int randomIndexEmoji = Random().nextInt(notificationEmoji.length);
    final int randomIndexTitle = Random().nextInt(notificationTitles.length);
    final int randomIndexBody = Random().nextInt(notificationBodies.length);
    final emoji = notificationEmoji.elementAt(randomIndexEmoji);
    final title = notificationTitles.elementAt(randomIndexTitle);
    final body = notificationBodies
        .elementAt(randomIndexBody)
        .replaceAll('{emoji}', emoji)
        .replaceAll('{plantName}', plantName)
        .replaceAll('{eventType}', eventTypeName);

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Notification channel for reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: 'ic_notification',
      color: Color.fromARGB(255, 58, 133, 60),
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await _notificationsPlugin.show(
        reminderToNotify.id, title, body, notificationDetails);

    await env.reminderRepository.updateLastNotified(reminderToNotify);
  }

  Future<void> scheduleReminderCheck() async {
    final bool notificationsEnabled = await _getNotificationsEnabled();
    if (!notificationsEnabled) {
      return;
    }

    final TimeOfDay notificationTime = await _getNotificationTime();
    final DateTime now = DateTime.now();
    DateTime targetTime = DateTime(now.year, now.month, now.day,
        notificationTime.hour, notificationTime.minute);

    final bool isToFire = targetTime.isBefore(now);
    if (isToFire) {
      await checkReminders();
      targetTime = targetTime.add(const Duration(days: 1));
    }

    final Duration durationUntilTarget = targetTime.difference(now);
    await Workmanager().registerPeriodicTask(
      "reminderUniqueName_${DateTime.now()}",
      reminderUniqueName,
      frequency: const Duration(hours: 24),
      initialDelay: durationUntilTarget,
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  Future<void> checkReminders() async {
    final ReminderOccurrenceService reminderOccurrenceService =
        ReminderOccurrenceService(env);
    final List<Reminder> reminderIdsToNotify =
        await reminderOccurrenceService.getRemindersToNotifyToday();

    for (final Reminder reminder in reminderIdsToNotify) {
      await _showReminderNotification(reminder);
    }
  }

  Future<void> sendTestNotification({String? message}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Notification channel for reminders',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: 'ic_notification',
      color: Color.fromARGB(255, 58, 133, 60),
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    const String testTitle = '🌵 Testing… 1, 2, Leaf';
    final String testBody = message ??
        "We're testing your notification system. Your plant said it's fine. For now.";

    await _notificationsPlugin.show(
      0,
      testTitle,
      testBody,
      notificationDetails,
    );
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
