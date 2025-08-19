import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/core/themes/colors.dart';
import 'package:plant_it/utils/common.dart';
import 'package:plant_it/utils/icons.dart';
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
            return _EventCard(
              event: e,
              viewModel: widget.viewModel,
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

class _EventCard extends StatelessWidget {
  final Event event;
  final CalendarViewModel viewModel;
  final Function(Event event) removeEvent;

  const _EventCard({
    required this.event,
    required this.viewModel,
    required this.removeEvent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.eventWithId(event.id)),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          viewModel.plants[event.plant]!.name,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          timeDiffStr(event.date),
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: AppColors.grey4),
        ),
        leading: _EventTypeAvatar(eventType: viewModel.eventTypes[event.type]!),
        trailing: PopupMenuButton<String>(
          padding: EdgeInsetsGeometry.all(0),
          icon: const Icon(Icons.more_vert, size: 25),
          onSelected: (value) {
            if (value == 'edit') {
              context.push(Routes.eventWithId(event.id));
            } else if (value == 'delete') {
              removeEvent(event);
            }
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(LucideIcons.pencil),
                  SizedBox(width: 10),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(LucideIcons.trash),
                  SizedBox(width: 10),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventTypeAvatar extends StatelessWidget {
  final EventType eventType;
  final double size = 45;

  const _EventTypeAvatar({required this.eventType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          MaterialShapes.arch(size: size, color: hexToColor(eventType.color)),
          Icon(appIcons[eventType.icon], size: 25, color: AppColors.black2),
        ],
      ),
    );
  }
}
