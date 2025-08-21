import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/user_setting_repository.dart';
import 'package:plant_it/domain/models/user_settings_keys.dart';
import 'package:result_dart/result_dart.dart';
import 'package:workmanager/workmanager.dart';

class SchedulingService {
  static const String taskName = "notification_task";
  final UserSettingRepository _userSettingRepository;
  final Workmanager _workmanager;
  final _log = Logger('SchedulingService');

  SchedulingService({
    required UserSettingRepository userSettingRepository,
    required Workmanager workmanager,
  })  : _userSettingRepository = userSettingRepository,
        _workmanager = workmanager;

  void updateSchedule() async {
    final List<UserSettingsKeys> dayKeys = [
      UserSettingsKeys.notificationTimeMonday,
      UserSettingsKeys.notificationTimeTuesday,
      UserSettingsKeys.notificationTimeWednesday,
      UserSettingsKeys.notificationTimeThursday,
      UserSettingsKeys.notificationTimeFriday,
      UserSettingsKeys.notificationTimeSaturday,
      UserSettingsKeys.notificationTimeSunday,
    ];

    for (UserSettingsKeys dayKey in dayKeys) {
      await _updateScheduleFor(dayKey);
    }
  }

  Future<void> _updateScheduleFor(UserSettingsKeys weekDayKey) async {
    Result<String> result =
        await _userSettingRepository.getOrDefault(weekDayKey.key, "");
    if (result.isError()) {
      return;
    }
    if (result.getOrThrow().isEmpty) {
      return;
    }

    TimeOfDay timeOfDay =
        _convertMinutesToTimeOfDay(int.parse(result.getOrThrow()));
    DateTime scheduledDateTime = _getScheduledDateTime(weekDayKey, timeOfDay);
    Duration difference = scheduledDateTime.difference(DateTime.now());

    if (difference.inSeconds < 0) {
      difference += Duration(days: 1);
    }

    // Ensure the minimum delay is 15 minutes
    // if (difference.inMinutes < 15) {
    //   difference = Duration(minutes: 15, seconds: 2);
    // }

    //Workmanager().cancelByUniqueName("${weekDayKey}_$taskName");
    Workmanager().registerPeriodicTask(
      "${weekDayKey}_$taskName",
      taskName,
      frequency: const Duration(hours: 24),
      initialDelay: difference,
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
    _log.info(
        "Registered notification task for ${weekDayKey.key} with initial delay ${difference.inSeconds} seconds");
  }

  DateTime _getScheduledDateTime(
      UserSettingsKeys weekDayKey, TimeOfDay timeOfDay) {
    DateTime now = DateTime.now();
    int daysToAdd = _getDaysUntilNextWeekday(weekDayKey);

    // Calculate the scheduled date
    DateTime scheduledDate = now.add(Duration(days: daysToAdd));
    return DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  int _getDaysUntilNextWeekday(UserSettingsKeys weekDayKey) {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday
    int targetWeekday = _getWeekdayFromKey(weekDayKey);

    if (targetWeekday >= currentWeekday) {
      return targetWeekday - currentWeekday;
    } else {
      return 7 - (currentWeekday - targetWeekday);
    }
  }

  int _getWeekdayFromKey(UserSettingsKeys weekDayKey) {
    switch (weekDayKey) {
      case UserSettingsKeys.notificationTimeMonday:
        return 1; // Monday
      case UserSettingsKeys.notificationTimeTuesday:
        return 2; // Tuesday
      case UserSettingsKeys.notificationTimeWednesday:
        return 3; // Wednesday
      case UserSettingsKeys.notificationTimeThursday:
        return 4; // Thursday
      case UserSettingsKeys.notificationTimeFriday:
        return 5; // Friday
      case UserSettingsKeys.notificationTimeSaturday:
        return 6; // Saturday
      case UserSettingsKeys.notificationTimeSunday:
        return 7; // Sunday
      default:
        throw InvalidDataException("weekDayKey $weekDayKey not valid");
    }
  }

  TimeOfDay _convertMinutesToTimeOfDay(int totalMinutes) {
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }
}
