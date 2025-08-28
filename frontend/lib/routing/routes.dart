abstract final class Routes {
  static const String home = '/';

  static final String _plantRelative = 'plant';
  static String plant = '/$_plantRelative';
  static String plantWithId(int id) => '/$_plantRelative/$id';
  static String editPlantWithId(int id) => '/$_plantRelative/$id/_edit';

  static const String _eventRelative = 'event';
  static const String event = '/$_eventRelative';
  static String eventWithId(int id) => '$event/$id';
  static const String activityFilter = '/activityFilter';

  static String settingsNotifications = '/settings-notifications';
  static String settingsInfo = '/settings-info';
  static String settingsDataSources = '/settings-dataSources';
  static String settingsFloraCodex = '/settings-dataSources/floraCodex';

  static final String _eventTypeRelative = 'eventType';
  static final String _eventTypesRelative = 'eventTypes';
  static String eventType = '/$_eventTypeRelative';
  static String eventTypes = '/$_eventTypesRelative';
  static String eventTypeWithId(int id) => '/$_eventTypeRelative/$id';

  static final String _reminderRelative = 'reminder';
  static final String _remindersRelative = 'reminders';
  static String reminder = '/$_reminderRelative';
  static String reminders = '/$_remindersRelative';
  static String reminderWithId(int id) => '/$_reminderRelative/$id';

  static final String _speciesRelative = 'species';
  static String species = '/$_speciesRelative';
  static String speciesWithIdOrExternal = '/${_speciesRelative}_view';
  static String speciesWithId(int id) => '/$_speciesRelative/$id';
}
