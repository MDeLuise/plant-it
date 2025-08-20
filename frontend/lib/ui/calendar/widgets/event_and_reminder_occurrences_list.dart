import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/core/themes/colors.dart';
import 'package:plant_it/ui/core/ui/event_card.dart';
import 'package:plant_it/ui/core/ui/reminder_occurrence_card.dart';
import 'package:result_dart/result_dart.dart';

class ActivityList extends StatefulWidget {
  final CalendarViewModel viewModel;
  final DateTime day;

  const ActivityList({
    super.key,
    required this.viewModel,
    required this.day,
  });

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  final List<dynamic> _activityForDay = [];

  @override
  void initState() {
    super.initState();
    _activityForDay.addAll(
        widget.viewModel.reminderOccurrencesForMonth[widget.day.day] ?? []);
    _activityForDay
        .addAll(widget.viewModel.eventsForMonth[widget.day.day] ?? []);
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
              _activityForDay.removeWhere((e) => e.id == event.id);
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: List.generate(
          max(_activityForDay.length * 2 - 1, 0),
          (index) {
            if (index.isEven) {
              if (_activityForDay[index ~/ 2] is Event) {
                final Event e = _activityForDay[index ~/ 2];
                return EventCard(
                  event: e,
                  eventType: widget.viewModel.eventTypes[e.type]!,
                  plant: widget.viewModel.plants[e.plant]!,
                  removeEvent: removeEvent,
                );
              } else {
                final ReminderOccurrence e = _activityForDay[index ~/ 2];
                return ReminderOccurrenceCard(
                  reminderOccurrence: e,
                  createEvent: widget.viewModel.createEventFromReminder,
                );
              }
            } else {
              return const Divider(
                  height: 16, thickness: 1, color: AppColors.grey1);
            }
          },
        ),
      ),
    );
  }
}
