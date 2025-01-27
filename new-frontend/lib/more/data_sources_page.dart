import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/environment.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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

  void _importData() {
    // Dummy function to handle the import action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Import started..."),
        duration: Duration(seconds: 2),
      ),
    );
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
