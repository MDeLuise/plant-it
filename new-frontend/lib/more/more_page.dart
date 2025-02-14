import 'package:plant_it/common.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/more/data_sources_page.dart';
import 'package:plant_it/more/event_type/event_type_list_page.dart';
import 'package:plant_it/more/reminder/reminder_list_page.dart';
import 'package:plant_it/more/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class MorePage extends StatefulWidget {
  final Environment env;

  const MorePage(this.env, {super.key});

  @override
  State<StatefulWidget> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          ListTile(
            title: const Text("Event Types"),
            subtitle: const Text("Manage the event types",
                style: TextStyle(color: Colors.grey)),
            leading: const Icon(LucideIcons.glass_water),
            onTap: () => navigateTo(context, EventTypeListPage(widget.env)),
          ),
          ListTile(
            title: const Text("Reminders"),
            subtitle: const Text("Manage the reminders",
                style: TextStyle(color: Colors.grey)),
            leading: const Icon(LucideIcons.clock),
            onTap: () =>
                navigateTo(context, ReminderListPage(widget.env, null)),
          ),
          ListTile(
            title: const Text("Data Sources"),
            subtitle: const Text("Manage the data sources",
                style: TextStyle(color: Colors.grey)),
            leading: const Icon(LucideIcons.text_search),
            onTap: () => navigateTo(context, DataSources(widget.env)),
          ),
          ListTile(
            title: const Text("Settings"),
            subtitle: const Text("Change the app's settings",
                style: TextStyle(color: Colors.grey)),
            leading: const Icon(LucideIcons.settings),
            onTap: () => navigateTo(context, Settings(widget.env)),
          ),
        ],
      ),
    );
  }
}
