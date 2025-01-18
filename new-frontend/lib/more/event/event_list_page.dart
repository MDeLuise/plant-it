import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/more/event/add_event.dart';

class EventsListPage extends StatefulWidget {
  final Environment env;

  const EventsListPage(this.env, {super.key});

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    widget.env.eventRepository.getAll().then((r) {
      setState(() {
        _events = r;
      });
    });
  }

  Future<void> _navigateToAddEvent() async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventPage(widget.env),
      ),
    );

    if (shouldRefresh == true) {
      _fetchEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddEvent,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          final eventIcon = event.icon;

          ListTile(
            leading: CircleAvatar(
              radius: 24,
              child: Icon(appIcons[eventIcon]),
            ),
          );
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: event.color != null
                  ? hexToColor(event.color!)
                  : Theme.of(context).colorScheme.primary,
              child: Icon(
                appIcons[eventIcon],
                color: Theme.of(context).colorScheme.surfaceDim,
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      if (event.description != null &&
                          event.description!.isNotEmpty)
                        Text(
                          event.description!,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: GestureDetector(
              onTap: () => {},
              child: const Icon(LucideIcons.trash_2),
            ),
          );
        },
      ),
    );
  }
}
