import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/reminder_repository.dart';
import 'package:plant_it/data/repository/user_setting_repository.dart';
import 'package:plant_it/data/service/notification_service.dart';
import 'package:plant_it/data/service/scheduling_service.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/user_settings_keys.dart';
import 'package:result_dart/result_dart.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({
    required UserSettingRepository userSettingRepository,
    required ReminderRepository reminderRepository,
    required SchedulingService schedulingService,
    required NotificationService notificationService,
  })  : _userSettingRepository = userSettingRepository,
        _reminderRepository = reminderRepository,
        _schedulingService = schedulingService,
        _notificationService = notificationService {
    load = Command.createAsyncNoParam(() async {
      Result<void> result = await _load();
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
    save = Command.createAsync((Map<String, String> newSettings) async {
      Result<void> result = await _put(newSettings);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
    saveNotificationTime =
        Command.createAsync((Map<String, int> notificationTime) async {
      int minute = notificationTime['minute']!;
      int hour = notificationTime['hour']!;
      int weekDay = notificationTime['weekDay']!;
      Result<void> result =
          await _setNotificationTimeForDay(minute, hour, weekDay);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
    removeAllNotificationTime = Command.createAsyncNoParam(() async {
      Result<void> result = await _removeAllNotificationTime();
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
    loadReminders = Command.createAsyncNoParam(() async {
      Result<void> result = await _loadReminders();
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: Failure(Exception("not started")));
  }

  final UserSettingRepository _userSettingRepository;
  final ReminderRepository _reminderRepository;
  final SchedulingService _schedulingService;
  final NotificationService _notificationService;
  final _log = Logger('SettingsViewModel');
  final Map<String, String> _userSettings = {};

  late final Command<void, void> load;
  late final Command<Map<String, String>, void> save;
  late final Command<Map<String, int>, void> saveNotificationTime;
  late final Command<void, void> removeAllNotificationTime;
  late final Command<void, void> loadReminders;

  final List<String> _dayKeys = [
    UserSettingsKeys.notificationTimeMonday.key,
    UserSettingsKeys.notificationTimeTuesday.key,
    UserSettingsKeys.notificationTimeWednesday.key,
    UserSettingsKeys.notificationTimeThursday.key,
    UserSettingsKeys.notificationTimeFriday.key,
    UserSettingsKeys.notificationTimeSaturday.key,
    UserSettingsKeys.notificationTimeSunday.key,
  ];
  final List<String> _dayKeysDateTime = [
    UserSettingsKeys.notificationDateTimeMonday.key,
    UserSettingsKeys.notificationDateTimeTuesday.key,
    UserSettingsKeys.notificationDateTimeWednesday.key,
    UserSettingsKeys.notificationDateTimeThursday.key,
    UserSettingsKeys.notificationDateTimeFriday.key,
    UserSettingsKeys.notificationDateTimeSaturday.key,
    UserSettingsKeys.notificationDateTimeSunday.key,
  ];
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  Future<Result<void>> _load() async {
    Result<List<UserSetting>> loadUserSettings = await _userSettingRepository.getAll();
    if (loadUserSettings.isError()) {
      return loadUserSettings.exceptionOrNull()!.toFailure();
    }
    for (UserSetting us in loadUserSettings.getOrThrow()) {
      _userSettings.putIfAbsent(us.key, () => us.value);
    }
    _log.fine('Loaded user settings');
    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _loadReminders() async {
    final reminders = await _reminderRepository.getAll();
    if (reminders.isError()) {
      return reminders.exceptionOrNull()!.toFailure();
    }
    _reminders = reminders.getOrThrow();
    _log.fine('Loaded reminders');
    notifyListeners();
    return Success("ok");
  }

  String? get(String key) {
    return _userSettings[key];
  }

  Future<Result<void>> _put(Map<String, String> newSettings) async {
    for (String k in newSettings.keys) {
      Result<void> result =
          await _userSettingRepository.put(k, newSettings[k]!);
      if (result.isError()) {
        return result.exceptionOrNull()!.toFailure();
      }
      _userSettings[k] = newSettings[k]!;
    }
    if (newSettings.containsKey(UserSettingsKeys.notificationEnabled.key) &&
        newSettings[UserSettingsKeys.notificationEnabled.key] == "true") {
      _notificationService.requireNotificationPermission();
    }
    _log.fine('Saved new user setting');
    notifyListeners();
    return Success("ok");
  }

  Future<Result<void>> _setNotificationTimeForDay(
      int minute, int hour, int weekDay) async {
    if (weekDay < 0 || weekDay > 6) {
      throw UnsupportedError("Day of the week $weekDay does not exist");
    }
    String key = _dayKeys[weekDay];
    String value = (hour * 60 + minute).toString();
    Result<void> result = await _put({key: value});
    _schedulingService.updateSchedule();
    return result;
  }

  Future<Result<void>> _removeAllNotificationTime() async {
    for (String k in _dayKeys) {
      Result<void> result = _userSettingRepository.remove(k);
      if (result.isError()) {
        return result.exceptionOrNull()!.toFailure();
      }
    }
    _log.fine('time notification settings removed');
    notifyListeners();
    return Success("ok");
  }

  List<bool> get notificationSelectedDays {
    return _dayKeys.map((dk) => _userSettings.containsKey(dk)).toList();
  }

  List<TimeOfDay?> get notificationTimeDays {
    return _dayKeys.map((dk) {
      if (!_userSettings.containsKey(dk)) {
        return null;
      }
      return _convertMinutesToTimeOfDay(int.parse(_userSettings[dk]!));
    }).toList();
  }

  List<String?> get notificationDateTimeDays {
    return _dayKeysDateTime.map((dk) {
      if (!_userSettings.containsKey(dk)) {
        return null;
      }
      return _userSettings[dk];
    }).toList();
  }

  TimeOfDay _convertMinutesToTimeOfDay(int totalMinutes) {
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    return TimeOfDay(hour: hours, minute: minutes);
  }
}
