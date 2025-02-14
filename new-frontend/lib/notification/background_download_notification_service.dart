import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BackgroundDownloadNotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'download_channel',
    'Download Progress',
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

  Future<void> showProgressNotification(int downloadedByte, int totalByte,
      String downloadedFormatted, String totalFormatted) async {
    double progress = (downloadedByte / totalByte) * 100;
    await _notificationsPlugin.show(
      1,
      'Downloading Species...',
      'Downloaded $downloadedFormatted of $totalFormatted',
      NotificationDetails(
        android: AndroidNotificationDetails(
          'download_channel',
          'Download Progress',
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

  Future<void> showCompletionNotification(int downloaded) async {
    await _notificationsPlugin.show(
      1,
      'Download Complete',
      'Successfully downloaded $downloaded bytes.',
      _platformChannelSpecifics,
    );
  }

  Future<void> showErrorNotification(dynamic error) async {
    await _notificationsPlugin.show(
      1,
      'Download Failed',
      'Error: $error',
      _platformChannelSpecifics,
    );
  }

  Future<void> showInitialNotification() async {
    await _notificationsPlugin.show(
      1,
      'Downloading Species...',
      'Preparing data...',
      _platformChannelSpecifics,
    );
  }
}
