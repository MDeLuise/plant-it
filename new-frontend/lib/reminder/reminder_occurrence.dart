import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';

class ReminderOccurrence {
  Future<List<int>> getReminderIdsToNotify(Environment env) async {
    final reminders = await env.reminderRepository.getAll();
    final now = DateTime.now();
    final List<int> reminderIdsToNotify = [];

    for (final reminder in reminders) {
      if (!reminder.enabled) continue;
      if (reminder.endDate != null && reminder.endDate!.isBefore(now)) continue;
      if (reminder.startDate.isAfter(now)) continue;

      final isDue = await _isReminderDue(env, reminder, now);
      if (!isDue) continue;

      final lastNotified = reminder.lastNotified ?? reminder.startDate;
      final nextNotification = _calculateNextNotification(
        lastNotified,
        reminder.repeatAfterUnit,
        reminder.repeatAfterQuantity,
      );

      if (nextNotification.isBefore(now)) {
        reminderIdsToNotify.add(reminder.id);
      }
    }

    return reminderIdsToNotify;
  }

  Future<bool> _isReminderDue(
      Environment env, Reminder reminder, DateTime now) async {
    final Event? lastEvent = await env.eventRepository.getLastFiltered([reminder.plant], [reminder.type]);

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
}
