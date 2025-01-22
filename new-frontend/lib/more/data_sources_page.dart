import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/environment.dart';

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
          // ListTile(
          //   title: const Text("BotanicaDB"),
          //   subtitle: const Text("Configure the BotanicaDB settings"),
          //   onTap: () => navigateTo(context, FloraCodexSettings(widget.env)),
          // ),
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
  State<FloraCodexSettings> createState() => _FloraCodexSetingsState();
}

class _FloraCodexSetingsState extends State<FloraCodexSettings> {
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
