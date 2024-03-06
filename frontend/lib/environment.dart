import 'package:plant_it/app_http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Environment {
  final SharedPreferences prefs;
  final AppHttpClient http;

  Environment({required this.prefs, required this.http});
}
