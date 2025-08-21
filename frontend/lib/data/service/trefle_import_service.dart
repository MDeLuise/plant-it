import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_it/data/repository/image_repository.dart';
import 'package:plant_it/data/repository/species_care_repository.dart';
import 'package:plant_it/data/repository/species_repository.dart';
import 'package:plant_it/data/repository/species_synonym_repository.dart';
import 'package:plant_it/database/database.dart';

/// To use only in callbackDispatcher
class TrefleImportService {
  static const String importTaskName = "trefle_import_task";
  static const String cleanupTaskName = "trefle_cleanup_task";
  late final SpeciesRepository _speciesRepository;
  late final SpeciesCareRepository _speciesCareRepository;
  late final SpeciesSynonymsRepository _speciesSynonymsRepository;
  late final ImageRepository _imageRepository;
  late final FlutterLocalNotificationsPlugin _notificationsPlugin;
  final String downloadUrl =
      "https://github.com/treflehq/dump/releases/download/1.0.0-alpha%2B20201015/species.csv";
  final String localFileName = "trefle_species.csv";
  final Logger _log = Logger("TrefleImportService");

  TrefleImportService() {
    AppDatabase db = AppDatabase();
    _speciesRepository = SpeciesRepository(db: db);
    _speciesCareRepository = SpeciesCareRepository(db: db);
    _speciesSynonymsRepository = SpeciesSynonymsRepository(db: db);
    _imageRepository = ImageRepository(db: db);
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> import(int offset, int limit) async {
    if (offset == 0) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$localFileName';
      File file = File(filePath);

      if (!await file.exists()) {
        _log.fine("Starting download of the file...");
        await _downloadFile();
      } else {
        _log.fine("File already exists. Skipping download.");
      }
    }
    // ...
  }

  Future<void> _downloadFile() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    await FlutterDownloader.enqueue(
      url: downloadUrl,
      headers: {},
      savedDir: appDocPath,
      showNotification: true,
      openFileFromNotification: false,
      fileName: localFileName,
    );
  }

  Future<void> cleanup() async {
    return _speciesRepository.deleteAllByDataSources(SpeciesDataSource.trefle);
  }
}
