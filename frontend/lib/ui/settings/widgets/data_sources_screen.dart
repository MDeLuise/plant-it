import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/domain/models/user_settings_keys.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/settings/view_models/settings_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workmanager/workmanager.dart';

// Strips leading/trailing whitespace and cuts the string at the first
// URL-fragment character (& ? # whitespace). Users pasting from their
// FloraCodex dashboard URL sometimes include trailing query fragments like
// "&q"; left unsanitized these inject a second `q=` parameter into the
// search URL, which makes FloraCodex return empty results silently.
String _sanitizeApiKey(String raw) {
  final trimmed = raw.trim();
  const delimiters = ['&', '?', '#', ' ', '\n', '\t', '\r'];
  int cut = trimmed.length;
  for (final d in delimiters) {
    final idx = trimmed.indexOf(d);
    if (idx != -1 && idx < cut) cut = idx;
  }
  return trimmed.substring(0, cut);
}

class DataSourcesScreen extends StatelessWidget {
  final SettingsViewModel viewModel;
  const DataSourcesScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L.of(context).dataSources)),
      body: SafeArea(
          child: Column(
        children: [
          GestureDetector(
            onTap: () =>
                context.push(Routes.settingsFloraCodex, extra: viewModel),
            child: ListTile(
              title: Text(L.of(context).floraCodex),
              subtitle: Text(L.of(context).configureTheFloraCodexSettings),
            ),
          ),
        ],
      )),
    );
  }
}

class FloraCodexScreen extends StatelessWidget {
  final SettingsViewModel viewModel;
  final Workmanager workmanager;

  const FloraCodexScreen({
    super.key,
    required this.workmanager,
    required this.viewModel,
  });

  Future<String?> _showApiKeyDialog(
      BuildContext context, String? initialValue) async {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(L.of(context).insertTheFloraCodexApiKey),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: L.of(context).enterApiKey),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(L.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                String apiKey = _sanitizeApiKey(controller.text);
                if (apiKey.isNotEmpty) {
                  viewModel.save.executeWithFuture({
                    UserSettingsKeys.floraCodexKey.key: apiKey,
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text(L.of(context).confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L.of(context).floraCodex)),
      body: SafeArea(
          child: ValueListenableBuilder(
              valueListenable: viewModel.save.results,
              builder: (context, value, child) {
                String? apiKey =
                    viewModel.get(UserSettingsKeys.floraCodexKey.key);
                bool useFloraCodex =
                    viewModel.get(UserSettingsKeys.useFloraCodex.key) == "true";
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          L.of(context).floraCodexDescription,
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          launchUrl(Uri.parse("https://floracodex.com/auth/sign-up"));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  L.of(context).floraCodexGetApiKey,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                LucideIcons.external_link,
                                color: Theme.of(context).colorScheme.primary,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(L.of(context).enableDataSource),
                        value: useFloraCodex,
                        onChanged: (bool value) {
                          viewModel.save.execute({
                            UserSettingsKeys.useFloraCodex.key:
                                (!useFloraCodex).toString()
                          });
                        },
                      ),
                      ListTile(
                        title: Text(L.of(context).apiKey),
                        subtitle: (apiKey ?? "").isEmpty
                            ? Text(L.of(context).notProvided)
                            : Text(
                                "${apiKey!.substring(0, min(5, apiKey.length))}..."),
                        trailing: const Icon(Icons.arrow_forward),
                        enabled: useFloraCodex,
                        onTap: () => _showApiKeyDialog(context, apiKey),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
