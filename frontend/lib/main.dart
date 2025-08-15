import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:plant_it/data/service/notification_service.dart';
import 'package:plant_it/ui/core/ui/scroll_behaviour.dart';
import 'package:workmanager/workmanager.dart';

import 'main_development.dart' as development;
import 'routing/router.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      NotificationService notificationService = NotificationService.noParam();
      await notificationService.sendDueReminderNotifications();
      
      return Future.value(true);
    } catch (error) {
      print('There is an error in the task $task: $error');
      return Future.error(error);
    }
  });
}

/// Default main method
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    //isInDebugMode: true,
  );
  NotificationService.noParam().initialize();

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
