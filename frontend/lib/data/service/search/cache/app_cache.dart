abstract class AppCache {
  static const String taskName = "clear_cache_task";

  Future<void> put(String key, String value);

  String? get(String key);

  Future<bool> delete(String key);

  Future<bool> clear();

  bool exists(String key);
}
