import 'package:plant_it/database/database.dart';

class ReminderOccurrence {
  final Reminder reminder;
  final DateTime nextOccurrence;

  ReminderOccurrence(this.reminder, this.nextOccurrence);
}
