import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/events_notifier.dart';
import 'package:plant_it/set_server.dart';
import 'package:plant_it/splash_screen.dart';
import 'package:plant_it/template.dart';
import 'package:plant_it/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:toastification/toastification.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.containsKey('serverKey');
    final AppHttpClient http = AppHttpClient();
    final Environment env = Environment(
      prefs: prefs,
      http: http,
      backendVersion: "",
      credentials: Credentials(
        username: "anonymous",
        email: "not@an.email",
      ),
      logger: TalkerFlutter.init(),
      notificationDispatcher: [],
      eventTypes: [],
      plants: [],
    );
    if (isLoggedIn) {
      if (prefs.containsKey('serverURL')) {
        final String? serverURL = prefs.getString("serverURL");
        if (serverURL != null) {
          http.backendUrl = serverURL;
        }
      }
      if (prefs.containsKey('serverKey')) {
        final String? serverKey = prefs.getString("serverKey");
        if (serverKey != null) {
          http.key = serverKey;
        }
      }
      if (prefs.containsKey('username')) {
        final String? username = prefs.getString("username");
        if (username != null) {
          env.credentials.username = username;
        }
      }
      if (prefs.containsKey('email')) {
        final String? email = prefs.getString("email");
        if (email != null) {
          env.credentials.email = email;
        }
      }
    }

    runApp(
      ChangeNotifierProvider(
        create: (context) => EventsNotifier(),
        child: Container(
          color: const Color(0xFF061913),
          child: Center(
            child: SizedBox(
              width: maxWidth,
              child: MaterialApp(
                title: 'Plant-it',
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                theme: theme,
                home: isLoggedIn ? SplashPage(env: env) : SetServer(env: env),
              ),
            ),
          ),
        ),
      ),
    );
  }, (error, stack) {
    if (error is AppException) {
      showSnackbar(
          navigatorKey.currentContext!, ToastificationType.error, error.cause);
    }
  });
}
