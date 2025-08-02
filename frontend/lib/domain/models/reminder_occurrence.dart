import 'package:plant_it/database/database.dart';

class ReminderOccurrence {
  final Reminder reminder;
  final DateTime nextOccurrence;
  final EventType eventType;
  final Plant plant;

  ReminderOccurrence({
    required this.reminder,
    required this.nextOccurrence,
    required this.eventType,
    required this.plant,
  });
}
