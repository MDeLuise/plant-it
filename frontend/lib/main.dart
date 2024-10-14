import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/change_notifiers.dart';
import 'package:plant_it/notify_conf_notifier.dart';
import 'package:plant_it/set_server.dart';
import 'package:plant_it/splash_screen.dart';
import 'package:plant_it/template.dart';
import 'package:plant_it/theme.dart';
import 'package:plant_it/toast/toast_manager.dart';
import 'package:plant_it/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    Locale? prefSavedLocale;
    if (prefs.containsKey('language_code')) {
      prefSavedLocale = Locale(
          prefs.getString('language_code')!, prefs.getString('country_code'));
    }

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => EventsNotifier()),
          ChangeNotifierProvider(create: (context) => PhotosNotifier()),
          ChangeNotifierProvider(create: (context) => NotifyConfNotifier()),
          ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ],
        child: Container(
          color: const Color(0xFF061913),
          child: Center(
            child: SizedBox(
              width: maxWidth,
              child: MyApp(
                env: env,
                isLoggedIn: isLoggedIn,
                prefSavedLocale: prefSavedLocale,
              ),
            ),
          ),
        ),
      ),
    );
  }, (error, stack) {
    if (error is AppException) {
      ToastificationToastManager().showToast(navigatorKey.currentContext!,
          ToastNotificationType.error, error.cause);
    }
  });
}

class MyApp extends StatefulWidget {
  final Environment env;
  final bool isLoggedIn;
  final Locale? prefSavedLocale;

  const MyApp({
    super.key,
    required this.env,
    required this.isLoggedIn,
    this.prefSavedLocale,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _updatedLocale;

  @override
  void initState() {
    super.initState();
    Provider.of<LocaleProvider>(context, listen: false).addListener(() async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('language_code')) {
        _updatedLocale = Locale(
            prefs.getString('language_code')!, prefs.getString('country_code'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Plant-it',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _updatedLocale ?? widget.prefSavedLocale ?? localeProvider.locale,
      theme: theme,
      home: widget.isLoggedIn
          ? SplashPage(env: widget.env)
          : SetServer(env: widget.env),
    );
  }
}
