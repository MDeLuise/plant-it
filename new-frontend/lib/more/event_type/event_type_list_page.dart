import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/more/event_type/add_event_type.dart';
import 'package:plant_it/more/event_type/edit_event_type.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      text: 'This will also delete all events of this type.',
      confirmBtnText: 'Delete',
      cancelBtnText: 'Cancel',
      title: "Delete event type?",
      confirmBtnColor: Colors.red,
      showCancelBtn: true,
      cancelBtnTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      textColor: Theme.of(context).colorScheme.onSurface,
      titleColor: Theme.of(context).colorScheme.onSurface,
      barrierColor: Theme.of(context).colorScheme.surface.withAlpha(200),
      backgroundColor: Theme.of(context).colorScheme.surface,
      onConfirmBtnTap: () {
        widget.env.eventTypeRepository.delete(eventId);
        _fetchEvents();
        Navigator.of(context).pop(true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Types'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: _navigateToAddEvent,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          final eventIcon = event.icon;

          return GestureDetector(
            onTap: () => _navigateToEditEvent(context, event),
            child: ListTile(
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
                onTap: () => _confirmAndDelete(context, event.id),
                child: const Icon(LucideIcons.trash_2),
              ),
            ),
          );
        },
      ),
    );
  }
}
