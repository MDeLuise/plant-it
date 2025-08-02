import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plant_it/ui/core/ui/scroll_behaviour.dart';

import 'main_development.dart' as development;
import 'routing/router.dart';

/// Default main method
void main() {
  // Launch development config by default
  development.main();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // see https://github.com/material-foundation/flutter-packages/issues/574#issuecomment-2635023116
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp.router(
        localizationsDelegates: [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          //AppLocalizationDelegate(),
        ],
        scrollBehavior: AppCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: lightColorScheme?.primary ?? Colors.green,
            dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: darkColorScheme?.primary ?? Colors.green,
            dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        routerConfig: router(),
      );
    });
  }
}
