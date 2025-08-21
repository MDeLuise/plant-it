import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/data/service/trefle_import_service.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:workmanager/workmanager.dart';

class DataSourcesScreen extends StatelessWidget {
  const DataSourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data sources')),
      body: SafeArea(
          child: Column(
        children: [
          GestureDetector(
            onTap: () => context.push(Routes.settingsTrefle),
            child: ListTile(
              title: Text("Trefle"),
              subtitle: Text("Import data from a Trefle bump"),
            ),
          ),
          // GestureDetector(
          //   onTap: () => {},
          //   child: ListTile(
          //     title: Text("Flora Codex"),
          //     subtitle: Text("Configure the Flora Codex settings"),
          //   ),
          // ),
        ],
      )),
    );
  }
}

class TrefleScreen extends StatelessWidget {
  final Workmanager workmanager;

  const TrefleScreen({
    super.key,
    required this.workmanager,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trefle')),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Trefle was an exceptional platform that provided detailed data on plant species, serving both enthusiasts and developers. "
              "Although Trefle has unfortunately shut down, you can still access a database dump of the species information and import it into this app.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            const Text(
              "Import Species",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Please be aware that due to the extensive amount of data, the import process may take a significant amount of time, potentially up to an hour, depending on your device. "
              "This is a one-time operation that will run in the background, allowing you to continue using your phone and this app as usual.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => workmanager.registerOneOffTask(
                  "trefle_import_${DateTime.timestamp()}",
                  TrefleImportService.importTaskName),
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
                    "Import Species Dump",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.surface),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Cleanup Imported Species",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Please be aware that the cleanup process may take some time, depending on your device. "
              "This is a one-time operation that will run in the background, allowing you to continue using your phone and this app as usual.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () => workmanager.registerOneOffTask(
                  "trefle_cleanup_${DateTime.timestamp()}",
                  TrefleImportService.cleanupTaskName),
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
                    LucideIcons.eraser,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Cleanup Imported Species",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.surface),
                  )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
