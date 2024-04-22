import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

class Environment {
  final SharedPreferences prefs;
  final AppHttpClient http;
  List<String> eventTypes;
  List<PlantDTO> plants;
  String backendVersion;
  Credentials credentials;
  Talker logger;
  List<NotificationDispatcher> notificationDispatcher;

  Environment({
    required this.prefs,
    required this.http,
    required this.backendVersion,
    required this.credentials,
    required this.logger,
    required this.notificationDispatcher,
    required this.eventTypes,
    required this.plants,
  });
}

class Credentials {
  String username;
  String email;
  DateTime? lastLogin;

  Credentials({
    required this.username,
    required this.email,
    this.lastLogin,
  });
}

class NotificationDispatcher {
  String name;
  bool enabled;

  NotificationDispatcher({
    required this.name,
    required this.enabled,
  });
}
