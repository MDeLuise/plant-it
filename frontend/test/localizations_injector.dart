import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LocalizationsInjector extends StatelessWidget {
  final Widget child;
  final NavigatorObserver navigatorObserver;
  const LocalizationsInjector(
      {super.key, required this.child, required this.navigatorObserver});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      navigatorObservers: [navigatorObserver],
      home: Scaffold(
        body: child,
      ),
    );
  }
}
