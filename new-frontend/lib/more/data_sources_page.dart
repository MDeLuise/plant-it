import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/custom_loading_dialog.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:csv/csv.dart';

class DataSources extends StatefulWidget {
  final Environment env;

  const DataSources(this.env, {super.key});

  @override
  State<DataSources> createState() => _DataSourcesState();
}

class _DataSourcesState extends State<DataSources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Sources"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Trefle"),
            subtitle: const Text("Configure the Trefle settings"),
            onTap: () => navigateTo(context, TrefleSettings(widget.env)),
          ),
          ListTile(
            title: const Text("Flora Codex"),
            subtitle: const Text("Configure the Flora Codex settings"),
            onTap: () => navigateTo(context, FloraCodexSettings(widget.env)),
          ),
        ],
      ),
    );
  }
}

class FloraCodexSettings extends StatefulWidget {
  final Environment env;

  const FloraCodexSettings(this.env, {super.key});

  @override
  State<FloraCodexSettings> createState() => _FloraCodexSettingsState();
}

class _FloraCodexSettingsState extends State<FloraCodexSettings> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool enableDataSource = false;
  bool _obscureText = true;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _saveSettingsToDB() async {
    widget.env.userSettingRepository
        .put('dataSource_floraCodex_enabled', enableDataSource.toString());
    widget.env.userSettingRepository
        .put('dataSource_floraCodex_apiKey', _apiKeyController.text);
  }

  Future<void> _loadSettingsFromDB() async {
    widget.env.userSettingRepository
        .getOrDefault('dataSource_floraCodex_enabled', 'false')
        .then((e) => setState(() => enableDataSource = e == 'true'));
    widget.env.userSettingRepository
        .getOrDefault('dataSource_floraCodex_apiKey', '')
        .then((a) => setState(() => _apiKeyController.text = a));
  }

  @override
  void initState() {
    super.initState();
    _loadSettingsFromDB();
    _apiKeyController.addListener(_saveSettingsToDB);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flora Codex Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text("Enable Data Source"),
              value: enableDataSource,
              onChanged: (e) {
                setState(() {
                  enableDataSource = e;
                });
                _saveSettingsToDB();
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: TextField(
                enabled: enableDataSource,
                controller: _apiKeyController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: "API Key",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? LucideIcons.eye_closed : LucideIcons.eye,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrefleSettings extends StatefulWidget {
  final Environment env;

  const TrefleSettings(this.env, {super.key});

  @override
  State<TrefleSettings> createState() => _TrefleSettingsState();
}

class _TrefleSettingsState extends State<TrefleSettings> {
  final String downloadUrl =
      "https://github.com/treflehq/dump/releases/download/1.0.0-alpha%2B20201015/species.csv";

  void _downloadData() async {
    try {
      // Request storage permission
      var status = await Permission.manageExternalStorage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied.")),
        );
        return;
      }

      //     // Define the Downloads folder path
      String downloadsFolder;
      if (Platform.isAndroid) {
        downloadsFolder =
            "/storage/emulated/0/Download"; // Common Downloads folder for Android
      } else if (Platform.isIOS) {
        Directory? iosDownloadsDirectory =
            await getApplicationDocumentsDirectory();
        downloadsFolder = iosDownloadsDirectory
            .path; // iOS doesn't have a public Downloads folder
      } else {
        throw Exception("Unsupported platform");
      }

      // Ensure the folder exists
      final directory = Directory(downloadsFolder);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Construct the file path
      final filePath = "$downloadsFolder/species.csv";

      // Show progress dialog with StatefulBuilder inside the widget parameter
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Downloading...',
        text:
            'Downloading file (~178 MB). This may take a few minutes. Please do not close the app or dismiss the dialog.',
        showCancelBtn: true,
        showConfirmBtn: false,
        barrierDismissible: false,
        customAsset: "packages/quickalert/assets/loading.gif",
      );

      // Download the file
      final url = Uri.parse(downloadUrl);
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File downloaded successfully: $filePath")),
        );
        Navigator.of(context).pop();
      } else {
        throw Exception("Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
      Navigator.of(context).pop();
    }
  }

  // void _downloadData() async {
  //   try {
  //     // Request storage permission
  //     var status = await Permission.manageExternalStorage.request();
  //     if (!status.isGranted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Storage permission denied.")),
  //       );
  //       return;
  //     }

  //     // Define the Downloads folder path
  //     String downloadsFolder;
  //     if (Platform.isAndroid) {
  //       downloadsFolder = "/storage/emulated/0/Download";
  //     } else if (Platform.isIOS) {
  //       Directory? iosDownloadsDirectory =
  //           await getApplicationDocumentsDirectory();
  //       downloadsFolder = iosDownloadsDirectory.path;
  //     } else {
  //       throw Exception("Unsupported platform");
  //     }

  //     // Ensure the folder exists
  //     final directory = Directory(downloadsFolder);
  //     if (!await directory.exists()) {
  //       await directory.create(recursive: true);
  //     }

  //     // Construct the file path
  //     final filePath = "$downloadsFolder/species.csv";
  //     final url = Uri.parse(downloadUrl);

  //     double progress = 0.0; // Initialize progress value

  //     // Show progress dialog with StatefulBuilder inside the widget parameter
  //     QuickAlert.show(
  //       context: context,
  //       type: QuickAlertType.loading,
  //       title: 'Downloading...',
  //       text: 'Please wait while the file is being downloaded (~178Mb). It will take some time.',
  //       showCancelBtn: false,
  //       customAsset: "packages/quickalert/assets/loading.gif",
  //     );

  //     // Download the file using a client for progress tracking
  //     final client = http.Client();
  //     final request = http.Request('GET', url);
  //     final response = await client.send(request);

  //     if (response.statusCode == 200) {
  //       final contentLength = response.contentLength ?? 0;
  //       final file = File(filePath);
  //       final sink = file.openWrite();

  //       int downloadedBytes = 0;

  //       await response.stream.listen(
  //         (chunk) {
  //           downloadedBytes += chunk.length;
  //           sink.add(chunk);

  //           // Update progress and refresh the dialog's progress bar
  //           print((downloadedBytes / contentLength) * 100);
  //           setState(() {
  //             progress = downloadedBytes / contentLength;
  //           });
  //         },
  //         onDone: () async {
  //           await sink.close();
  //           Navigator.of(context).pop(); // Close progress dialog
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //                 content: Text("File downloaded successfully: $filePath")),
  //           );
  //         },
  //         onError: (e) {
  //           Navigator.of(context).pop(); // Close progress dialog
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(content: Text("Download failed: $e")),
  //           );
  //         },
  //         cancelOnError: true,
  //       );
  //     } else {
  //       Navigator.of(context).pop(); // Close progress dialog
  //       throw Exception("Failed to download file: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     Navigator.of(context).pop(); // Close progress dialog
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Download failed: $e")),
  //     );
  //   }
  // }

  void _importDataOLD() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['tsv', 'csv'],
      );

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No file selected.")),
        );
        return;
      }

      // QuickAlert.show(
      //   context: context,
      //   type: QuickAlertType.loading,
      //   title: 'Parsing the file...',
      //   text:
      //       'Parsing the file. Please do not close the app or dismiss the dialog.',
      //   showCancelBtn: true,
      //   showConfirmBtn: false,
      //   barrierDismissible: false,
      //   customAsset: "packages/quickalert/assets/loading.gif",
      // );

      int imported = 0;
      final File file = File(result.files.single.path!);
      final String fileContents = await file.readAsString();

      final List<List<String>> rows = const CsvToListConverter(
        fieldDelimiter: '\t',
        shouldParseNumbers: false,
        eol: '\n',
        allowInvalid: false,
        convertEmptyTo: "",
      ).convert(fileContents);
      rows.removeAt(0);

      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Importing Species...',
        text:
            '[$imported] Importing species (~${rows.length} species). This may take a few minutes. Please do not close the app or dismiss the dialog.',
        showCancelBtn: true,
        showConfirmBtn: false,
        barrierDismissible: false,
        customAsset: "packages/quickalert/assets/loading.gif",
      );

      for (var row in rows) {
        print("imported $imported...");
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

        final bool alreadyExists = (await widget.env.speciesRepository
                .getExternal(SpeciesDataSource.trefle, id)) !=
            null;

        if (!alreadyExists) {
          // insert species
          int insertedId =
              await widget.env.speciesRepository.insert(SpeciesCompanion.insert(
            scientificName: scientificName,
            family: family,
            genus: genus,
            species: scientificName,
            author: drift.Value(author),
            avatarUrl: drift.Value(imageUrl),
            externalId: drift.Value(id),
            dataSource: const drift.Value(SpeciesDataSource.trefle),
          ));

          // insert synonyms
          if (synonyms != null && synonyms.isNotEmpty) {
            var synonymsList = synonyms.split(',');
            for (var synonym in synonymsList) {
              await widget.env.speciesSynonymsRepository
                  .insert(SpeciesSynonymsCompanion.insert(
                species: insertedId,
                synonym: synonym,
              ));
            }
          }
          //imported++;
          setState(() {
            imported = imported + 1;
          });
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Data imported successfully ($imported species were imported).")),
      );
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during import: $e")),
      );
      Navigator.of(context).pop();
    }
  }

  void _importData() async {
    final GlobalKey<CustomLoadingDialogState> dialogKey = GlobalKey();
    const int batchSize = 2500;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['tsv', 'csv'],
      );

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No file selected.")),
        );
        return;
      }

      CustomLoadingDialog.show(
        context: context,
        title: 'Importing Species...',
        text:
            'Importing species. This may take a few minutes. Please do not close the app or dismiss the dialog.',
        dialogKey: dialogKey,
      );

      final File file = File(result.files.single.path!);
      final Stream<String> fileStream = file
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      List<List<String>> rows = [];
      int imported = 0;
      int totalRows = 0;

      await for (var line in fileStream) {
        totalRows++;
      }

      // Reset the stream position
      final Stream<String> resetFileStream = file
          .openRead()
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (var line in resetFileStream) {
        // Split line by tab to match the TSV format
        List<String> row = line.split('\t');
        rows.add(row);

        if (rows.length >= batchSize) {
          // Process the batch of rows
          await _processBatch(rows, dialogKey);
          imported += batchSize;

          // Update progress dialog after processing the batch
          double progress = (imported / totalRows) * 100;
          if (dialogKey.currentState != null) {
            dialogKey.currentState!.updatePercentage(progress);
          }

          rows.clear(); // Reset rows for the next batch
        }
      }

      // Process any remaining rows in case the last batch is smaller than batchSize
      if (rows.isNotEmpty) {
        await _processBatch(rows, dialogKey);
        imported += rows.length;
        double progress = (imported / totalRows) * 100;
        if (dialogKey.currentState != null) {
          dialogKey.currentState!.updatePercentage(progress);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Data imported successfully ($imported species were imported)."),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during import: $e")),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _processBatch(List<List<String>> rows,
      GlobalKey<CustomLoadingDialogState> dialogKey) async {
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

      final bool alreadyExists = (await widget.env.speciesRepository
              .getExternal(SpeciesDataSource.trefle, id)) !=
          null;

      if (!alreadyExists) {
        speciesToInsert.add(SpeciesCompanion(
          scientificName: drift.Value(scientificName),
          family: drift.Value(family),
          genus: drift.Value(genus),
          species: drift.Value(scientificName),
          author: drift.Value(author),
          avatarUrl: drift.Value(imageUrl),
          externalId: drift.Value(id),
          dataSource: const drift.Value(SpeciesDataSource.trefle),
        ));

        if (synonyms != null && synonyms.isNotEmpty) {
          var synonymsList = synonyms.split(',');
          for (var synonym in synonymsList) {
            synonymsToInsert.add(SpeciesSynonymsCompanion(
              species: drift.Value(int.parse(id)),
              synonym: drift.Value(synonym),
            ));
          }
        }
      }
    }
    await widget.env.speciesRepository.insertAll(speciesToInsert);

    synonymsToInsert.map((synonym) async {
      final int speciesId = (await widget.env.speciesRepository.getExternal(
              SpeciesDataSource.trefle, synonym.id.value.toString()))!
          .id;
      return SpeciesSynonymsCompanion(
        species: drift.Value(speciesId),
        synonym: synonym.synonym,
      );
    });
    widget.env.speciesSynonymsRepository.insertAll(synonymsToInsert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trefle Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About Trefle",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Trefle was an incredible platform that provided detailed plant species data, helping enthusiasts and developers alike. "
              "Unfortunately, Trefle has been shut down. However, you can still access a dump of the species database and import it into this app.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              "Species Database",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "You can download the species database dump in CSV format using the button below. Once downloaded, it can be imported and used within the app.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _downloadData,
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.download,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Download Species Dump",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.surface),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Import Database",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Once you have downloaded the species database, you can import it into the app. The imported data will allow you to access plant species information seamlessly.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: _importData,
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.secondary),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.upload,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Import Species Dump",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
