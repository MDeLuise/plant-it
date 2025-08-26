import 'package:plant_it/data/service/search/cache/app_cache.dart';
import 'package:plant_it/database/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppCachePref extends AppCache {
  final String _speciesDetails = 'species';
  final String _speciesSearch = 'species_search';
  final SharedPreferences _pref;

  AppCachePref({
    required SharedPreferences pref,
  }) : _pref = pref;

  @override
  Future<bool> clear() {
    return _pref.clear();
  }

  @override
  Future<bool> deleteSpeciesDetails(String id, SpeciesDataSource source) {
    return _pref.remove("${_speciesDetails}_${source.name}_${id.toString()}");
  }

  @override
  Future<bool> deleteSpeciesSearch(String term) {
    return _pref.remove(_speciesSearch + term);
  }

  @override
  String? getSpeciesDetails(String id, SpeciesDataSource source) {
    return _pref.getString("${_speciesDetails}_${source.name}_${id.toString()}");
  }

  @override
  String? getSpeciesSearch(String term) {
    return _pref.getString(_speciesSearch + term);
  }

  @override
  Future<void> saveSpeciesDetails(String id, SpeciesDataSource source, String value) {
    return _pref.setString("${_speciesDetails}_${source.name}_${id.toString()}", value);
  }

  @override
  Future<void> saveSpeciesSearch(String term, String value) {
    return _pref.setString(_speciesSearch + term, value);
  }
  
  @override
  Future<void> clearSearch() async {
    for (String s in _pref.getKeys().where((k) => k.startsWith(_speciesSearch))) {
      await _pref.remove(s);
    }
  }
}
