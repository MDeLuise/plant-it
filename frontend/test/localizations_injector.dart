import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plant_it/events_notifier.dart';
import 'package:plant_it/theme.dart';
import 'package:provider/provider.dart';

class LocalizationsInjector extends StatelessWidget {
  final Widget child;
  final NavigatorObserver navigatorObserver;
  const LocalizationsInjector({
    super.key,
    required this.child,
    required this.navigatorObserver,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventsNotifier(),
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
        ],
        theme: theme,
        navigatorObservers: [navigatorObserver],
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }
}
