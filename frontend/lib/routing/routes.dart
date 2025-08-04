abstract final class Routes {
  static const String home = '/';
  static const String plantRelative = 'plant';
  static const String plant = '/$plantRelative';
  static String plantWithId(int id) => '$plant/$id';
  static const String eventRelative = 'event';
  static const String event = '/$eventRelative';
  static String eventWithId(int id) => '$event/$id';
}