import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/alert_box.dart';
import 'package:plant_it/app_pages.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/more/event_type/add_event_type.dart';
import 'package:plant_it/more/event_type/edit_event_type.dart';

class EventTypeListPage extends StatefulWidget {
  final Environment env;

  const EventTypeListPage(this.env, {super.key});

  @override
  State<EventTypeListPage> createState() => _EventTypesListPageState();
}

class _EventTypesListPageState extends State<EventTypeListPage> {
  List<EventType> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    widget.env.eventTypeRepository.getAll().then((r) {
      setState(() {
        _events = r
          ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      });
    });
  }

  Future<void> _navigateToAddEvent() async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventTypePage(widget.env),
      ),
    );

    if (shouldRefresh == true) {
      _fetchEvents();
    }
  }

  Future<void> _navigateToEditEvent(
      BuildContext context, EventType toEdit) async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventTypePage(widget.env, toEdit),
      ),
    );

    if (shouldRefresh == true) {
      _fetchEvents();
    }
  }

  Future<dynamic> _confirmAndDelete(BuildContext context, int eventId) {
    return showDialog(
      context: context,
      builder: (context) => AlertBox(
        icon: LucideIcons.circle_alert,
        btnIcon: LucideIcons.trash,
        color: Colors.red,
        title: "Delete event type?",
        message: "This will also delete all events of this type.",
        onConfirm: () {
          widget.env.eventTypeRepository.delete(eventId);
          _fetchEvents();
        },
        isCancelVisible: true,
        okText: "Remove",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListPage(
      addEntityCallback: _navigateToAddEvent,
      title: "Event Types",
      child: Column(
        children: _events.map((e) {
          return GestureDetector(
            onTap: () => _navigateToEditEvent(context, e),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: e.color != null
                    ? hexToColor(e.color!)
                    : Theme.of(context).primaryColor,
                child: Icon(
                  appIcons[e.icon],
                  color: Theme.of(context).colorScheme.surfaceDim,
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.name),
                          if (e.description != null &&
                              e.description!.isNotEmpty)
                            Text(
                              e.description!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _confirmAndDelete(context, e.id),
                    child: Icon(
                      LucideIcons.trash_2,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
