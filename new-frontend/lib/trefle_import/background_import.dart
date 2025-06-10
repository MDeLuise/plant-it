import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/notification/background_import_notification_service.dart';
import 'package:workmanager/workmanager.dart';

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/notification/background_import_notification_service.dart';
import 'package:workmanager/workmanager.dart';

Future<void> importSpecies(
    Environment env, Map<String, dynamic>? inputData) async {
  const int batchSize = 2500;
  const int iterationPerWork = 10;

  // print(
  //     "start progress: ${inputData?['progress'] ?? '0'}, file: ${inputData?['filePath']}");

  final BackgroundImportNotificationService notificationService =
      BackgroundImportNotificationService();

  File? tempFile;

  try {
    final originalFilePath = inputData?['filePath'];
    final progress = int.tryParse(inputData?['progress'] ?? '0') ?? 0;

    if (originalFilePath == null) {
      throw ArgumentError('Missing filePath in inputData');
    }

    final Directory? tempDir = await getExternalStorageDirectory();
    final String tempFileName = path.basename(originalFilePath);
    final String tempFilePath = path.join(tempDir!.path, tempFileName);
    final originalFile = File(originalFilePath);

    tempFile = File(tempFilePath);
    if (progress == 0) {
      final bool originalExists = await originalFile.exists();
      final bool tempExists = await tempFile.exists();

      if (!originalExists && !tempExists) {
        throw FileSystemException(
            "Import file not found in original or temp path", originalFilePath);
      }

      if (!tempExists && originalExists) {
        await originalFile.copy(tempFilePath);
      }

      // Show initial notification
      await notificationService.showInitialNotification();
    }

    // Count total lines
    int totalRows = 0;
    await for (var _ in tempFile
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      totalRows++;
    }

    // Prepare to import
    final Stream<String> lineStream = tempFile
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    final List<List<String>> rows = [];
    int lineCount = 0;
    int iteration = 0;
    int imported = 0;

    await for (var line in lineStream) {
      if (lineCount < progress) {
        lineCount++;
        continue;
      }

      final List<String> row = line.split('\t');
      rows.add(row);
      lineCount++;

      if (rows.length >= batchSize) {
        await _processBatch(env, rows);
        imported += rows.length;
        await notificationService.showProgressNotification(
            lineCount, totalRows);
        rows.clear();
        iteration++;
      }

      if (iteration >= iterationPerWork) {
        //print("call next Workmanager()");
        // Schedule next chunk
        await Workmanager().registerOneOffTask(
          "import_species_${DateTime.now().millisecondsSinceEpoch}",
          "import_species_task",
          inputData: {
            'filePath': tempFilePath,
            'progress': lineCount.toString(),
          },
          initialDelay: const Duration(seconds: 1),
        );
        return;
      }
    }

    if (rows.isNotEmpty) {
      await _processBatch(env, rows);
      imported += rows.length;
      await notificationService.showProgressNotification(lineCount, totalRows);
    }

    await notificationService.showCompletionNotification(imported);
    await tempFile.delete();
  } catch (e, st) {
    await notificationService.showErrorNotification("${e.toString()}\n$st");
    if (tempFile != null && await tempFile.exists()) {
      await tempFile.delete();
    }
  }
}

Future<void> _processBatch(Environment env, List<List<String>> rows) async {
  final List<SpeciesCompanion> speciesToInsert = [];
  final List<ImagesCompanion> imagesToInsert = [];
  final List<SpeciesSynonymsCompanion> synonymsToInsert = [];
  final List<SpeciesCareCompanion> speciesCareToInsert = [];
  for (var row in rows) {
    if (row.length != 54) {
      //print("Skipped $row");
      continue;
    }
    final String id = row[0];
    final String scientificName = row[1];
    final String rank = row[2];
    final String genus = row[3];
    final String family = row[4];
    final String year = row[5];
    final String author = row[6];
    final String bibliography = row[7];
    final String commonName = row[8];
    // final String? familyCommonName = row[9];
    final String imageUrl = row[10];
    final String flowerColor = row[11];
    final String flowerConspicuous = row[12];
    final String foliageColor = row[13];
    final String foliageTexture = row[14];
    final String fruitColor = row[15];
    final String fruitConspicuous = row[16];
    final String fruitMonths = row[17];
    final String bloomMonths = row[18];
    // final String? groundHumidity = row[19];
    // final String? growthForm = row[20];
    // final String? growthHabit = row[21];
    // final String? growthMonths = row[22];
    // final String? growthRate = row[23];
    // final String? ediblePart = row[24];
    // final String? vegetable = row[25];
    // final String? edible = row[26];
    final String light = row[27];
    // final String? soilNutriments = row[28];
    // final String? soilSalinity = row[29];
    // final String? anaerobicTolerance = row[30];
    final String atmosphericHumidity = row[31];
    final String averageHeightCm = row[32];
    final String maximumHeightCm = row[33];
    final String minimumRootDepthCm = row[34];
    final String phMaximum = row[35];
    final String phMinimum = row[36];
    // final String? plantingDaysToHarvest = row[37];
    // final String? plantingDescription = row[38];
    // final String? plantingSowingDescription = row[39];
    // final String? plantingRowSpacingCm = row[40];
    // final String? plantingSpreadCm = row[41];
    final String synonyms = row[42];
    // final String? distributions = row[43];
    final String commonNames = row[44];
    // final String? urlUsda = row[45];
    // final String? urlTropicos = row[46];
    // final String? urlTelaBotanica = row[47];
    // final String? urlPowo = row[48];
    // final String? urlPlantnet = row[49];
    // final String? urlGbif = row[50];
    // final String? urlOpenfarm = row[51];
    // final String? urlCatminat = row[52];
    // final String? urlWikipediaEn = row[53];

    if (rank != "species") {
      continue;
    }

    final bool alreadyExists = (await env.speciesRepository
            .getExternal(SpeciesDataSource.trefle, id)) !=
        null;

    if (alreadyExists) {
      return;
    }

    speciesToInsert.add(SpeciesCompanion(
      scientificName: Value(scientificName),
      family: Value(family),
      genus: Value(genus),
      species: Value(scientificName),
      author: Value(author),
      externalId: Value(id),
      dataSource: const Value(SpeciesDataSource.trefle),
      year: _stringToInt(year),
    ));

    if (imageUrl.isNotEmpty) {
      //print("Found images for $scientificName");
      imagesToInsert.add(ImagesCompanion(
        speciesId: Value(int.parse(id)),
        isAvatar: Value(true),
        imageUrl: Value(imageUrl),
        createdAt: Value(DateTime.now()),
      ));
    }

    if (synonyms.isNotEmpty || commonNames.isNotEmpty) {
      final List<String> synonymsList = synonyms.split(',');
      if (commonNames.isNotEmpty) {
        synonymsList.addAll(commonNames.split(','));
      }
      if (commonName.isNotEmpty) {
        synonymsList.add(commonName);
      }
      for (var synonym in synonymsList) {
        synonymsToInsert.add(SpeciesSynonymsCompanion(
          species: Value(int.parse(id)),
          synonym: Value(synonym),
        ));
      }
    }

    speciesCareToInsert.add(SpeciesCareCompanion(
      phMin: _stringToInt(phMinimum),
      phMax: _stringToInt(phMaximum),
      light: _stringToInt(light),
      humidity: _stringToInt(atmosphericHumidity).present
          ? Value(_stringToInt(atmosphericHumidity).value * 10)
          : Value.absent(),
      species: Value(int.parse(id)),
    ));
  }
  await env.speciesRepository.insertAll(speciesToInsert);
  //print("Inserted ${speciesToInsert.length} species");

  await env.imageRepository.insertAll(imagesToInsert);
  //print("Inserted ${imagesToInsert.length} species avatar urls");

  speciesCareToInsert.map((care) async {
    final int speciesId = (await env.speciesRepository.getExternal(
            SpeciesDataSource.trefle, care.species.value.toString()))!
        .id;
    return care.copyWith(
      species: Value(speciesId),
    );
  });
  await env.speciesCareRepository.insertAll(speciesCareToInsert);
  //print("Inserted ${speciesCareToInsert.length} species cares");

  synonymsToInsert.map((synonym) async {
    final int speciesId = (await env.speciesRepository.getExternal(
            SpeciesDataSource.trefle, synonym.id.value.toString()))!
        .id;
    return SpeciesSynonymsCompanion(
      species: Value(speciesId),
      synonym: synonym.synonym,
    );
  });
  await env.speciesSynonymsRepository.insertAll(synonymsToInsert);
  //print("Inserted ${synonymsToInsert.length} species synonyms");
}

Value<int> _stringToInt(String? toParse) {
  return toParse != null && toParse.isNotEmpty
      ? Value(double.parse(toParse).round())
      : const Value.absent();
}
