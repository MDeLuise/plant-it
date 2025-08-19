abstract final class Routes {
  static const String home = '/';
  static String plantsRelative = 'plants';
  static String plantWithId(int id) => '/$plantsRelative/$id';
  static const String event = '/event';
  static String eventWithId(int id) => '/$event/$id';
  static const String activityFilter = '/activityFilter';
  static String settingsNotifications = '/settings-notifications';
  static String eventTypes = '/eventTypes';
  static String eventType = '/eventType';
  static String eventTypeWithId(int id) => '/$eventTypes/$id';
}
