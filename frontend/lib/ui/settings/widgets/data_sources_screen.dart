import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/domain/models/user_settings_keys.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/settings/view_models/settings_viewmodel.dart';
import 'package:workmanager/workmanager.dart';

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
                String apiKey = controller.text.trim();
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
