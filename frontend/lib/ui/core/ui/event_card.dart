import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/core/themes/colors.dart';
import 'package:plant_it/utils/common.dart';
import 'package:plant_it/utils/icons.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final EventType eventType;
  final Plant plant;
  final Function(Event event) removeEvent;

  const EventCard({
    super.key,
    required this.event,
    required this.removeEvent,
    required this.eventType,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.eventWithId(event.id)),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          plant.name,
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
        leading: _EventTypeAvatar(eventType: eventType),
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
          MaterialShapes.circle(size: size, color: hexToColor(eventType.color)),
          Icon(appIcons[eventType.icon], size: 25, color: AppColors.black2),
        ],
      ),
    );
  }
}
