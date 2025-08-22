import 'package:plant_it/data/service/search/cache/search_result_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResultCachePref extends SearchResultCache {
  final SharedPreferences _pref;

  SearchResultCachePref({
    required SharedPreferences pref,
  }) : _pref = pref;

  @override
  Future<void> put(String key, String value) {
    return _pref.setString(key, value);
  }

  @override
  String? get(String key) {
    return _pref.getString(key);
  }

  @override
  Future<bool> delete(String key) {
    return _pref.remove(key);
  }

  @override
  Future<bool> clear() {
    return _pref.clear();
  }

  @override
  bool exists(String key) {
    return _pref.containsKey(key);
  }
}
