import 'package:flutter/material.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/set_server.dart';
import 'package:plant_it/template.dart';
import 'package:plant_it/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.containsKey('key');
  final AppHttpClient http = AppHttpClient();
  final Environment env = Environment(prefs: prefs, http: http);

  runApp(MaterialApp(
    title: 'Plant-it',
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: theme,
    home: isLoggedIn ? TempletePage(env: env) : SetServer(env: env),
  ));
}
