abstract final class Routes {
  static const String home = '/';
  static const String plantRelative = 'plant';
  static const String plant = '/$plantRelative';
  static String plantWithId(int id) => '$plant/$id';
}