import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/settings/view_models/settings_viewmodel.dart';

class DatabaseAndCacheScreen extends StatelessWidget {
  final SettingsViewModel viewModel;

  const DatabaseAndCacheScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    L appLocalizations = L.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(appLocalizations.databaseAndCache)),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(appLocalizations.clearCache),
              leading: Icon(LucideIcons.eraser),
              onTap: () async {
                await viewModel.clearCache.executeWithFuture();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(appLocalizations.cacheCleaned)),
                );
              },
            ),
            ListTile(
              title: Text(appLocalizations.reloadNotificationMessages),
              leading: Icon(LucideIcons.message_square_dot),
              onTap: () async {
                await viewModel.clearNotificationMessages();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(appLocalizations.notificationMessagesReloaded)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
