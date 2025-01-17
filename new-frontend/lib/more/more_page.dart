import 'package:plant_it/common.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/more/event/event_list_page.dart';
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
    return ListView(
      children: [
        ListTile(
          title: const Text("Events"),
          subtitle: const Text("Manage the event types"),
          leading: const Icon(LucideIcons.boxes),
          onTap: () => navigateTo(context, EventsListPage(widget.env)),
        ),
        ListTile(
          title: const Text("Settings"),
          subtitle: const Text("Change the app's settings"),
          leading: const Icon(LucideIcons.settings),
          onTap: () => navigateTo(context, Settings(widget.env)),
        ),
      ],
    );
  }
}
