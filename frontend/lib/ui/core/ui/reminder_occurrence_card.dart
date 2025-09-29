import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/core/themes/colors.dart';
import 'package:plant_it/utils/common.dart';
import 'package:plant_it/utils/icons.dart';

class ReminderOccurrenceCard extends StatelessWidget {
  final ReminderOccurrence reminderOccurrence;
  final Command<ReminderOccurrence, void> createEvent;

  const ReminderOccurrenceCard({
    super.key,
    required this.reminderOccurrence,
    required this.createEvent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push(Routes.reminderWithId(reminderOccurrence.reminder.id)),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          reminderOccurrence.plant.name,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Row(
          children: [
            Text(
              timeDiffStr(reminderOccurrence.nextOccurrence, L.of(context)),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(" • "),
            Text(
              L.of(context).frequencyEvery(
                    reminderOccurrence.reminder.frequencyQuantity,
                    reminderOccurrence.reminder.frequencyUnit.name,
                  ),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: AppColors.grey4,
                  ),
            ),
          ],
        ),
        leading: _EventTypeAvatar(eventType: reminderOccurrence.eventType),
        trailing: PopupMenuButton<String>(
          padding: EdgeInsetsGeometry.all(0),
          icon: const Icon(Icons.more_vert, size: 25),
          onSelected: (value) async {
            if (value == 'reminder') {
              context
                  .push(Routes.reminderWithId(reminderOccurrence.reminder.id));
            } else if (value == 'done') {
              await createEvent.executeWithFuture(reminderOccurrence);
              if (createEvent.results.value.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(createEvent.results.value.error.toString()),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(L.of(context).eventCreated),
                  ),
                );
              }
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 'done',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(LucideIcons.check),
                  SizedBox(width: 10),
                  Text(L.of(context).markDone),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'reminder',
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(LucideIcons.clock),
                  SizedBox(width: 10),
                  Text(L.of(context).reminder),
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
          MaterialShapes.square(size: size, color: hexToColor(eventType.color)),
          Icon(appIcons[eventType.icon], size: 25, color: AppColors.black2),
        ],
      ),
    );
  }
}
