import 'package:plant_it/database/database.dart';

abstract class AppCache {
  static const String taskName = "clear_cache_task";
  static const String emptyChar = "*";

  Future<void> saveSpeciesDetails(String id, SpeciesDataSource source, String value);
  
  Future<void> saveSpeciesSearch(String term, String value);

  String? getSpeciesDetails(String id, SpeciesDataSource source);

  String? getSpeciesSearch(String term);

  Future<bool> deleteSpeciesDetails(String id, SpeciesDataSource source);
  
  Future<bool> deleteSpeciesSearch(String term);

  Future<bool> clear();

  Future<void> clearSearch();
}
