import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/notification/background_import_notification_service.dart';

Future<void> importSpecies(
    Environment env, Map<String, dynamic>? inputData) async {
  const int batchSize = 2500;
  int imported = 0;
  int totalRows = 0;

  final notificationService = BackgroundImportNotificationService();

  try {
    final File file = File(inputData!['filePath']);

    final Stream<String> fileStream =
        file.openRead().transform(utf8.decoder).transform(const LineSplitter());

    List<List<String>> rows = [];

    await notificationService.showInitialNotification();

    await for (var _ in fileStream) {
      totalRows++;
    }

    final Stream<String> resetFileStream =
        file.openRead().transform(utf8.decoder).transform(const LineSplitter());

    await for (var line in resetFileStream) {
      List<String> row = line.split('\t');
      rows.add(row);

      if (rows.length >= batchSize) {
        await _processBatch(env, rows);
        imported += batchSize;

        await notificationService.showProgressNotification(imported, totalRows);

        rows.clear();
      }
    }

    if (rows.isNotEmpty) {
      await _processBatch(env, rows);
    }

    await notificationService.showCompletionNotification(imported);
  } catch (e) {
    await notificationService.showErrorNotification(e);
  }
}

Future<void> _processBatch(Environment env, List<List<String>> rows) async {
  final List<SpeciesCompanion> speciesToInsert = [];
  final List<SpeciesSynonymsCompanion> synonymsToInsert = [];
  for (var row in rows) {
    if (row.length != 54) {
      print("Skipped $row");
      continue;
    }
    final String id = row[0];
    final String scientificName = row[1];
    final String rank = row[2];
    final String genus = row[3];
    final String family = row[4];
    final String? year = row[5];
    final String? author = row[6];
    final String? bibliography = row[7];
    final String? commonName = row[8];
    final String? familyCommonName = row[9];
    final String? imageUrl = row[10];
    final String? flowerColor = row[11];
    final String? flowerConspicuous = row[12];
    final String? foliageColor = row[13];
    final String? foliageTexture = row[14];
    final String? fruitColor = row[15];
    final String? fruitConspicuous = row[16];
    final String? fruitMonths = row[17];
    final String? bloomMonths = row[18];
    final String? groundHumidity = row[19];
    final String? growthForm = row[20];
    final String? growthHabit = row[21];
    final String? growthMonths = row[22];
    final String? growthRate = row[23];
    final String? ediblePart = row[24];
    final String? vegetable = row[25];
    final String? edible = row[26];
    final String? light = row[27];
    final String? soilNutriments = row[28];
    final String? soilSalinity = row[29];
    final String? anaerobicTolerance = row[30];
    final String? atmosphericHumidity = row[31];
    final String? averageHeightCm = row[32];
    final String? maximumHeightCm = row[33];
    final String? minimumRootDepthCm = row[34];
    final String? phMaximum = row[35];
    final String? phMinimum = row[36];
    final String? plantingDaysToHarvest = row[37];
    final String? plantingDescription = row[38];
    final String? plantingSowingDescription = row[39];
    final String? plantingRowSpacingCm = row[40];
    final String? plantingSpreadCm = row[41];
    final String? synonyms = row[42];
    final String? distributions = row[43];
    final String? commonNames = row[44];
    final String? urlUsda = row[45];
    final String? urlTropicos = row[46];
    final String? urlTelaBotanica = row[47];
    final String? urlPowo = row[48];
    final String? urlPlantnet = row[49];
    final String? urlGbif = row[50];
    final String? urlOpenfarm = row[51];
    final String? urlCatminat = row[52];
    final String? urlWikipediaEn = row[53];

    if (rank != "species") {
      continue;
    }

    final bool alreadyExists = (await env.speciesRepository
            .getExternal(SpeciesDataSource.trefle, id)) !=
        null;

    if (!alreadyExists) {
      speciesToInsert.add(SpeciesCompanion(
        scientificName: Value(scientificName),
        family: Value(family),
        genus: Value(genus),
        species: Value(scientificName),
        author: Value(author),
        avatarUrl: Value(imageUrl),
        externalId: Value(id),
        dataSource: const Value(SpeciesDataSource.trefle),
      ));

      if (synonyms != null && synonyms.isNotEmpty) {
        var synonymsList = synonyms.split(',');
        for (var synonym in synonymsList) {
          synonymsToInsert.add(SpeciesSynonymsCompanion(
            species: Value(int.parse(id)),
            synonym: Value(synonym),
          ));
        }
      }
    }
  }
  await env.speciesRepository.insertAll(speciesToInsert);

  synonymsToInsert.map((synonym) async {
    final int speciesId = (await env.speciesRepository.getExternal(
            SpeciesDataSource.trefle, synonym.id.value.toString()))!
        .id;
    return SpeciesSynonymsCompanion(
      species: Value(speciesId),
      synonym: synonym.synonym,
    );
  });
  env.speciesSynonymsRepository.insertAll(synonymsToInsert);
}
