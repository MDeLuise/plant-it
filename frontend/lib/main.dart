import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/set_server.dart';
import 'package:plant_it/template.dart';
import 'package:plant_it/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void reportError(BuildContext? context, FlutterErrorDetails details) {
  if (context == null) {
    print('Caught error: ${details.exception}');
    print('Stack trace:\n${details.stack}');
    return;
  }
  showSnackbar(context, ContentType.failure, details.exception.toString());
  //print('Caught error: ${details.exception}');
  //print('Stack trace:\n${details.stack}');
}

void main() async {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  FlutterError.onError = (FlutterErrorDetails details) {
    reportError(scaffoldMessengerKey.currentContext, details);
  };
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.containsKey('serverKey');
  final AppHttpClient http = AppHttpClient();
  final Environment env = Environment(
      prefs: prefs, http: http, scaffoldMessengerKey: scaffoldMessengerKey);
  if (isLoggedIn) {
    if (prefs.containsKey('serverURL')) {
      final String? serverURL = prefs.getString("serverURL");
      if (serverURL != null) {
        http.setBackendUrl(serverURL);
      }
    }
    if (prefs.containsKey('serverKey')) {
      final String? serverKey = prefs.getString("serverKey");
      if (serverKey != null) {
        http.addAuthorizationHeader(serverKey);
      }
    }
  }

  runApp(MaterialApp(
    title: 'Plant-it',
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: theme,
    home: isLoggedIn ? TempletePage(env: env) : SetServer(env: env),
  ));
}
