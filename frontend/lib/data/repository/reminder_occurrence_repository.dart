import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:plant_it/data/service/reminder_occurrence_service.dart';
import 'package:result_dart/result_dart.dart';

class ReminderOccurrenceRepository {
  final ReminderOccurrenceService _service;

  ReminderOccurrenceRepository({required ReminderOccurrenceService service})
      : _service = service;

  Future<Result<List<ReminderOccurrence>>> getNextOccurrences(int num) {
    return _service.getNextOccurrences(num);
  }

  Future<Result<List<ReminderOccurrence>>> getNextOccurrencesOfReminder(
      Reminder reminder, int num) {
    return _service.getNextOccurrencesOfReminder(reminder, num);
  }

  Future<Result<List<ReminderOccurrence>>> getForMonth(
      DateTime day, List<int>? plantIds, List<int>? eventTypeIds) {
    return _service.getForMonth(day, plantIds, eventTypeIds);
  }
}
