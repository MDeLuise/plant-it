import 'dart:async';
import 'dart:math';

import 'package:plant_it/database/database.dart';
import 'package:plant_it/data/repository/event_repository.dart';
import 'package:plant_it/data/repository/reminder_repository.dart';
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:result_dart/result_dart.dart';

class ReminderOccurrenceService {
  final ReminderRepository _reminderRepository;
  final EventRepository _eventRepository;

  ReminderOccurrenceService(
      {required ReminderRepository reminderRepository, required EventRepository eventRepository})
      : _reminderRepository = reminderRepository,
        _eventRepository = eventRepository;

  Future<Result<List<Reminder>>> getRemindersToNotifyToday() async {
    Result<List<Reminder>> reminders = await _reminderRepository.getAll();
    if (reminders.isError()) {
      return reminders.exceptionOrNull()!.toFailure();
    }
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    List<Reminder> result = [];

    for (Reminder reminder in reminders.getOrThrow()) {
      if (!reminder.enabled) continue;
      if (reminder.endDate != null && reminder.endDate!.isBefore(startOfDay)) {
        continue;
      }
      if (reminder.startDate.isAfter(endOfDay)) {
        continue;
      }

      bool isDue = await _isReminderDue(reminder, now);
      if (!isDue) {
        continue;
      }

      DateTime occurrence = reminder.lastNotified ?? reminder.startDate;

      do {
        occurrence = _calculateNextNotification(
            occurrence, reminder.repeatAfterUnit, reminder.repeatAfterQuantity);

        if (occurrence.isAfter(startOfDay) && occurrence.isBefore(endOfDay)) {
          result.add(reminder);
          break;
        }
      } while (occurrence.isBefore(endOfDay));
    }

    return result.toSuccess();
  }

  Future<bool> _isReminderDue(Reminder reminder, DateTime now) async {
    Result<Event>? lastEvent = await _eventRepository
        .getLastFiltered([reminder.plant], [reminder.type]);

    if (lastEvent == null) {
      return true;
    }

    DateTime nextDueDate = _calculateNextNotification(
      lastEvent.getOrThrow().date,
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
    }
  }

  Future<Result<List<ReminderOccurrence>>> getNextOccurrences(int num) async {
    Result<List<Reminder>> reminders = await _reminderRepository.getAll();
    if (reminders.isError()) {
      return reminders.exceptionOrNull()!.toFailure();
    }
    List<ReminderOccurrence> result = [];

    for (Reminder reminder in reminders.getOrThrow()) {
      Result<List<ReminderOccurrence>> reminderOccurrences =
          await getNextOccurrencesOfReminder(reminder, num);
      if (reminderOccurrences.isError()) {
        return reminderOccurrences.exceptionOrNull()!.toFailure();
      }
      result.addAll(reminderOccurrences.getOrThrow());
    }
    result.sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));
    return Success(result.sublist(0, min(result.length, num)));
  }

  Future<Result<List<ReminderOccurrence>>> getNextOccurrencesOfReminder(
      Reminder reminder, int num) async {
    final DateTime now = DateTime.now();
    final List<ReminderOccurrence> result = [];

    final Result<Event>? lastEvent = await _eventRepository
        .getLastFiltered([reminder.plant], [reminder.type]);
    if (lastEvent != null && lastEvent.isError()) {
      return lastEvent.exceptionOrNull()!.toFailure();
    }

    DateTime dateIterator;
    if (lastEvent != null) {
      dateIterator = lastEvent.getOrThrow().date;
    } else {
      dateIterator = reminder.startDate;
    }

    do {
      dateIterator = _calculateNextNotification(
          dateIterator, reminder.frequencyUnit, reminder.frequencyQuantity);
    } while (dateIterator.isBefore(now));

    while (result.length < num) {
      if (reminder.endDate != null && dateIterator.isAfter(reminder.endDate!)) {
        return result.toSuccess();
      }
      result.add(ReminderOccurrence(reminder, dateIterator));
      dateIterator = _calculateNextNotification(
          dateIterator, reminder.frequencyUnit, reminder.frequencyQuantity);
    }
    return result.toSuccess();
  }

  Future<Result<List<ReminderOccurrence>>> getForMonth(
      DateTime day, List<int>? plantIds, List<int>? eventTypeIds) async {
    final Result<List<Reminder>> reminders =
        await _reminderRepository.getFiltered(plantIds, eventTypeIds);
    if (reminders.isError()) {
      return reminders.exceptionOrNull()!.toFailure();
    }
    final List<ReminderOccurrence> result = [];

    final DateTime startOfMonth = DateTime(day.year, day.month, 1);
    final DateTime endOfMonth = DateTime(day.year, day.month + 1, 1)
        .subtract(const Duration(seconds: 1));

    for (Reminder reminder in reminders.getOrThrow()) {
      if (!reminder.enabled) continue;
      if (reminder.endDate != null &&
          reminder.endDate!.isBefore(startOfMonth)) {
        continue;
      }
      if (reminder.startDate.isAfter(endOfMonth)) {
        continue;
      }

      final Result<Event>? lastEvent = await _eventRepository
          .getLastFiltered([reminder.plant], [reminder.type]);
      if (lastEvent != null && lastEvent.isError()) {
        lastEvent.exceptionOrNull()!.toFailure();
      }

      DateTime occurrence =
          lastEvent != null ? lastEvent.getOrThrow().date : reminder.startDate;

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

    return result.toSuccess();
  }
}
