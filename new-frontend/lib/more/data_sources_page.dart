import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plant_it/app_pages.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/search/fetcher/flora_codex/flora_codex_fetcher.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:workmanager/workmanager.dart';

class DataSources extends StatefulWidget {
  final Environment env;

  const DataSources(this.env, {super.key});

  @override
  State<DataSources> createState() => _DataSourcesState();
}

class _DataSourcesState extends State<DataSources> {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: "Data Sources",
      child: Column(
        children: [
          ListTile(
            title: const Text("Trefle"),
            subtitle: const Text("Configure the Trefle settings",
                style: TextStyle(color: Colors.grey)),
            onTap: () => navigateTo(context, TrefleSettings(widget.env)),
          ),
          ListTile(
            title: const Text("Flora Codex"),
            subtitle: const Text("Configure the Flora Codex settings",
                style: TextStyle(color: Colors.grey)),
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
    if (enableDataSource && _apiKeyController.text.isNotEmpty) {
      widget.env.speciesFetcherFacade
          .addNext(FloraCodexFetcher(_apiKeyController.text));
    } else {
      widget.env.speciesFetcherFacade.remove(SpeciesDataSource.floraCodex);
    }
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
    return AppPage(
      title: 'Flora Codex Settings',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Enable Data Source"),
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
    var status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      showSnackbar(
          context, FeedbackLevel.error, "Storage permission denied", null);
      return;
    }

    String? directoryPath = await FilePicker.platform
        .getDirectoryPath(initialDirectory: "/storage/emulated/0/Download");

    if (directoryPath == null) {
      showSnackbar(context, FeedbackLevel.error, "No directory selected", null);
      return;
    }

    final filePath = "$directoryPath/species.csv";
    bool procede = true;

    await QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: "Download in Background",
      text:
          'This operation will run in the background. If you want to track progress, please enable app notifications.',
      showCancelBtn: true,
      confirmBtnText: "OK",
      cancelBtnText: "Cancel",
      textColor: Theme.of(context).colorScheme.onSurface,
      titleColor: Theme.of(context).colorScheme.onSurface,
      barrierColor: Colors.grey.withAlpha(200),
      cancelBtnTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      barrierDismissible: false,
      customAsset: "packages/quickalert/assets/loading.gif",
      onCancelBtnTap: () {
        procede = false;
        Navigator.of(context).pop();
      },
    );
    if (!procede) {
      return;
    }

    await Permission.notification.request();
    await Workmanager().registerOneOffTask(
      "download_species",
      "download_species_task",
      inputData: {
        "filePath": filePath,
        "downloadUrl": downloadUrl,
      },
    );
    showSnackbar(
        context, FeedbackLevel.info, "Import started in the background", null);
  }

  void _importData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['tsv', 'csv'],
    );

    if (result == null) {
      showSnackbar(context, FeedbackLevel.error, "No file selected", null);
      return;
    }

    bool procede = true;
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: "Importing Species",
      text:
          'This operation will take some time and will run in the background. '
          'If you want to track progress, please enable app notifications.',
      showCancelBtn: true,
      confirmBtnText: "OK",
      cancelBtnText: "Cancel",
      barrierDismissible: false,
      cancelBtnTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      textColor: Theme.of(context).colorScheme.onSurface,
      titleColor: Theme.of(context).colorScheme.onSurface,
      barrierColor: Colors.grey.withAlpha(200),
      backgroundColor: Theme.of(context).colorScheme.surface,
      customAsset: "packages/quickalert/assets/loading.gif",
      onCancelBtnTap: () {
        procede = false;
        Navigator.of(context).pop();
      },
    );
    if (!procede) {
      return;
    }

    await Permission.notification.request();
    await Workmanager().registerOneOffTask(
      "import_species_${DateTime.now().millisecond}",
      "import_species_task",
      inputData: {"filePath": result.files.single.path, "progress": '0'},
    );
    showSnackbar(
        context, FeedbackLevel.info, "Import started in the background", null);
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Trefle Settings',
      child: Padding(
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
