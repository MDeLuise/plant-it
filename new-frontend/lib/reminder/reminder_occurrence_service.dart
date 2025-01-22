import 'dart:async';
import 'dart:math';

import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/reminder/reminder_occurrence.dart';

class ReminderOccurrenceService {
  final Environment env;

  ReminderOccurrenceService(this.env);

  Future<List<Reminder>> getRemindersToNotifyToday() async {
    final List<Reminder> reminders = await env.reminderRepository.getAll();
    final DateTime now = DateTime.now();
    final DateTime startOfDay = DateTime(now.year, now.month, now.day);
    final DateTime endOfDay =
        DateTime(now.year, now.month, now.day, 23, 59, 59);
    final List<Reminder> result = [];

    for (final Reminder reminder in reminders) {
      if (!reminder.enabled) continue;
      if (reminder.endDate != null && reminder.endDate!.isBefore(startOfDay)) {
        continue;
      }
      if (reminder.startDate.isAfter(endOfDay)) {
        continue;
      }

      final bool isDue = await _isReminderDue(env, reminder, now);
      if (!isDue) {
        continue;
      }

      DateTime occurrence = reminder.lastNotified ?? reminder.startDate;

      do {
        occurrence = _calculateNextNotification(
            occurrence, reminder.repeatAfterUnit, reminder.repeatAfterQuantity);
      } while (occurrence.isBefore(endOfDay));

      if (occurrence.isAfter(startOfDay) && occurrence.isBefore(endOfDay)) {
        result.add(reminder);
        break;
      }
    }

    return result;
  }

  Future<bool> _isReminderDue(
      Environment env, Reminder reminder, DateTime now) async {
    final Event? lastEvent = await env.eventRepository
        .getLastFiltered([reminder.plant], [reminder.type]);

    if (lastEvent == null) {
      return true;
    }

    final nextDueDate = _calculateNextNotification(
      lastEvent.date,
      reminder.frequencyUnit,
      reminder.frequencyQuantity,
    );

    return nextDueDate.isBefore(now);
  }

  DateTime _calculateNextNotification(
      DateTime lastOccurrence, FrequencyUnit unit, int quantity) {
    switch (unit) {
      case FrequencyUnit.days:
        return lastOccurrence.add(Duration(days: quantity));
      case FrequencyUnit.weeks:
        return lastOccurrence.add(Duration(days: 7 * quantity));
      case FrequencyUnit.months:
        return DateTime(
          lastOccurrence.year,
          lastOccurrence.month + quantity,
          lastOccurrence.day,
          lastOccurrence.hour,
          lastOccurrence.minute,
          lastOccurrence.second,
        );
      case FrequencyUnit.years:
        return DateTime(
          lastOccurrence.year + quantity,
          lastOccurrence.month,
          lastOccurrence.day,
          lastOccurrence.hour,
          lastOccurrence.minute,
          lastOccurrence.second,
        );
      default:
        throw Exception("Unsupported frequency unit: $unit");
    }
  }

  Future<List<ReminderOccurrence>> getNextOccurrences(int num) async {
    final List<Reminder> reminders = await env.reminderRepository.getAll();
    final List<ReminderOccurrence> result = [];

    for (final Reminder reminder in reminders) {
      final List<ReminderOccurrence> reminderOccurrences =
          await getNextOccurrencesOfReminder(reminder, num);
      result.addAll(reminderOccurrences);
    }
    result.sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));
    return result.sublist(0, min(result.length, num));
  }

  Future<List<ReminderOccurrence>> getNextOccurrencesOfReminder(
      Reminder reminder, int num) async {
    final DateTime now = DateTime.now();
    final List<ReminderOccurrence> result = [];

    final Event? lastEvent = await env.eventRepository
        .getLastFiltered([reminder.plant], [reminder.type]);

    DateTime dateIterator;
    if (lastEvent != null) {
      dateIterator = lastEvent.date;
    } else {
      dateIterator = reminder.startDate;
    }

    do {
      dateIterator = _calculateNextNotification(
          dateIterator, reminder.frequencyUnit, reminder.frequencyQuantity);
    } while (dateIterator.isBefore(now));

    while (result.length < num) {
      if (reminder.endDate != null && dateIterator.isAfter(reminder.endDate!)) {
        return result;
      }
      result.add(ReminderOccurrence(reminder, dateIterator));
      dateIterator = _calculateNextNotification(
          dateIterator, reminder.frequencyUnit, reminder.frequencyQuantity);
    }
    return result;
  }

  Future<List<ReminderOccurrence>> getForMonth(DateTime day, List<int>? plantIds, List<int>? eventTypeIds) async {
    final List<Reminder> reminders = await env.reminderRepository.getFiltered(plantIds, eventTypeIds);
    final List<ReminderOccurrence> result = [];

    final DateTime startOfMonth = DateTime(day.year, day.month, 1);
    final DateTime endOfMonth = DateTime(day.year, day.month + 1, 1)
        .subtract(const Duration(seconds: 1));

    for (final Reminder reminder in reminders) {
      if (!reminder.enabled) continue;
      if (reminder.endDate != null &&
          reminder.endDate!.isBefore(startOfMonth)) {
        continue;
      }
      if (reminder.startDate.isAfter(endOfMonth)) {
        continue;
      }

      final Event? lastEvent = await env.eventRepository
          .getLastFiltered([reminder.plant], [reminder.type]);

      DateTime occurrence =
          lastEvent != null ? lastEvent.date : reminder.startDate;

      do {
        occurrence = _calculateNextNotification(
            occurrence, reminder.frequencyUnit, reminder.frequencyQuantity);
      } while (occurrence.isBefore(startOfMonth));

      while (occurrence.isBefore(endOfMonth)) {
        result.add(ReminderOccurrence(reminder, occurrence));
        occurrence = _calculateNextNotification(
            occurrence, reminder.frequencyUnit, reminder.frequencyQuantity);
      }
    }

    return result;
  }
}
