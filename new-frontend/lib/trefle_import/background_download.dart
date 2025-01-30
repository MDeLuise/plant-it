import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:plant_it/notification/background_download_notification_service.dart';

Future<void> downloadFile(Map<String, dynamic>? inputData) async {
  if (inputData == null || !inputData.containsKey('downloadUrl')) {
    print("Error: No download URL provided.");
    return;
  }

  final filePath =
      inputData['filePath'] ?? "/storage/emulated/0/Download/species.csv";
  final url = Uri.parse(inputData['downloadUrl']);
  final notificationService = BackgroundDownloadNotificationService();

  await notificationService.showInitialNotification();

  final client = http.Client();
  try {
    final request = http.Request('GET', url);
    final response = await client.send(request);

    if (response.statusCode != 200) {
      throw Exception(
          "Failed to download file. HTTP Status: ${response.statusCode}");
    }

    final totalBytes = response.contentLength ?? 0;
    int downloadedBytes = 0;

    final file = File(filePath);
    final sink = file.openWrite();

    await response.stream.listen(
      (List<int> chunk) async {
        sink.add(chunk);

        downloadedBytes += chunk.length;

        await notificationService.showProgressNotification(
    downloadedBytes, totalBytes, _formatBytes(downloadedBytes), _formatBytes(totalBytes));
      },
      onDone: () async {
        await notificationService.showCompletionNotification(downloadedBytes);
        await sink.close();
      },
      onError: (error) async {
        await notificationService.showErrorNotification(error);
        await sink.close();
      },
      cancelOnError: true,
    ).asFuture();
  } catch (e) {
    await notificationService.showErrorNotification(e.toString());
  } finally {
    client.close();
  }
}

String _formatBytes(int bytes, {int decimals = 2}) {
  if (bytes <= 0) return "0 B";

  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB"];
  final i = (bytes > 0) ? (log(bytes) / log(1024)).floor() : 0;
  final formattedSize = (bytes / pow(1024, i)).toStringAsFixed(decimals);

  return "$formattedSize ${suffixes[i]}";
}
