abstract class SearchResultCache {
  final int _retentionDays;

  SearchResultCache({
    required int retentionDays,
  }) : _retentionDays = retentionDays;

  Future<void> put(String key, String value);

  String? get(String key);

  Future<bool> delete(String key);

  Future<bool> clear();

  bool exists(String key);
}
