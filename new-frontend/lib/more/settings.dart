import 'package:plant_it/cache/cache.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings extends StatefulWidget {
  final Environment env;

  const Settings(this.env, {super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _appVersion = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Database"),
            subtitle: const Text("Import and Export options"),
            leading: const Icon(Icons.storage),
            onTap: () => navigateTo(context, const DatabaseSettings()),
          ),
          ListTile(
            title: const Text("Cache"),
            subtitle: const Text("Manage cache"),
            leading: const Icon(Icons.cached),
            onTap: () => navigateTo(context, CacheSettings(widget.env.cache)),
          ),
          ListTile(
            title: const Text("App Info"),
            subtitle: const Text("Version and details about the app"),
            leading: const Icon(Icons.info),
            onTap: () => navigateTo(context, AppInfo(appVersion: _appVersion)),
          ),
        ],
      ),
    );
  }
}

class DatabaseSettings extends StatelessWidget {
  const DatabaseSettings({super.key});

  @override
  Widget build(BuildContext context) {
    //final dbManager = DBManager();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Database Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Import Data"),
            leading: const Icon(Icons.file_upload),
            onTap: () async {
              //await dbManager.importDatabase();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Import completed!")),
              );
            },
          ),
          ListTile(
            title: const Text("Export Data"),
            leading: const Icon(Icons.file_download),
            onTap: () async {
              //await dbManager.exportDatabase();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Export completed!")),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CacheSettings extends StatelessWidget {
  final Cache cache;

  const CacheSettings(this.cache, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cache Settings"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Clean Cache"),
            leading: const Icon(Icons.cleaning_services),
            onTap: () {
              cache.removeAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Cache cleaned!")),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AppInfo extends StatelessWidget {
  final String appVersion;

  const AppInfo({super.key, required this.appVersion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Version: $appVersion"),
            const Text("..."),
          ],
        ),
      ),
    );
  }
}
