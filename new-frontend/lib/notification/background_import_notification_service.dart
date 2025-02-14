import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BackgroundImportNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'import_channel',
    'Import Progress',
    importance: Importance.low,
    onlyAlertOnce: true,
    showProgress: true,
    maxProgress: 100,
    enableVibration: false,
    playSound: false,
    icon: 'ic_notification',
    color: Color.fromARGB(255, 58, 133, 60),
  );

  static const NotificationDetails _platformChannelSpecifics =
      NotificationDetails(android: _androidNotificationDetails);

  Future<void> showProgressNotification(int imported, int totalRows) async {
    double progress = (imported / totalRows) * 100;
    await _notificationsPlugin.show(
      0,
      'Importing Species...',
      'Imported $imported of $totalRows species.',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'import_channel',
          'Import Progress',
          importance: Importance.low,
          showProgress: true,
          maxProgress: 100,
          progress: progress.toInt(),
          onlyAlertOnce: true,
          enableVibration: false,
          playSound: false,
        ),
      ),
    );
  }

  Future<void> showCompletionNotification(int imported) async {
    await _notificationsPlugin.show(
      0,
      'Import Complete',
      'Successfully imported $imported species.',
      _platformChannelSpecifics,
    );
  }

  Future<void> showErrorNotification(dynamic error) async {
    await _notificationsPlugin.show(
      0,
      'Import Failed',
      'Error: $error',
      _platformChannelSpecifics,
    );
  }

  Future<void> showInitialNotification() async {
    await _notificationsPlugin.show(
      0,
      'Importing Species...',
      'Preparing data...',
      _platformChannelSpecifics,
    );
  }
}
