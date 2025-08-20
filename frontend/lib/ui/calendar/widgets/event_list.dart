import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/core/themes/colors.dart';
import 'package:plant_it/ui/core/ui/event_card.dart';
import 'package:result_dart/result_dart.dart';

class EventList extends StatefulWidget {
  final CalendarViewModel viewModel;
  final DateTime day;

  const EventList({
    super.key,
    required this.viewModel,
    required this.day,
  });

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  List<Event> _eventForDay = [];

  @override
  void initState() {
    super.initState();
    _eventForDay = widget.viewModel.eventsForMonth[widget.day.day] ?? [];
  }

  void removeEvent(Event event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Result<void> deleteResult =
                  await widget.viewModel.deleteEvent(event);
              if (deleteResult.isError()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(deleteResult.exceptionOrNull().toString()),
                  ),
                );
                return;
              }
              _eventForDay.removeWhere((e) => e.id == event.id);
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Event deleted"),
                ),
              );
              context.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        max(_eventForDay.length * 2 - 1, 0),
        (index) {
          if (index.isEven) {
            final Event e = _eventForDay[index ~/ 2];
            return EventCard(
              event: e,
              eventType: widget.viewModel.eventTypes[e.type]!,
              plant: widget.viewModel.plants[e.plant]!,
              removeEvent: removeEvent,
            );
          } else {
            return const Divider(
                height: 16, thickness: 1, color: AppColors.grey1);
          }
        },
      ),
    );
  }
}
