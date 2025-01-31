import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/reminder/reminder_occurrence.dart';
import 'package:plant_it/reminder/reminder_occurrence_service.dart';

class PlantReminderWidgetGenerator {
  final Environment env;
  final Plant plant;
  final Map<int, EventType> eventTypes = {};

  PlantReminderWidgetGenerator(this.env, this.plant) {
    env.eventTypeRepository.getAll().then((rl) {
      for (EventType eventType in rl) {
        eventTypes[eventType.id] = eventType;
      }
    });
  }

  Future<List<PlantReminderInfoWidget>> getWidgets() async {
    final ReminderOccurrenceService reminderOccurrenceService =
        ReminderOccurrenceService(env);

    final List<Reminder> plantReminders =
        await env.reminderRepository.getFiltered([plant.id], null);
    final List<ReminderOccurrence> plantRemindersOccurrences = [];
    for (Reminder r in plantReminders) {
      plantRemindersOccurrences.add(
          (await reminderOccurrenceService.getNextOccurrencesOfReminder(r, 1))
              .first);
    }

    return plantRemindersOccurrences
        .map((ro) => PlantReminderInfoWidget(
            eventTypes[ro.reminder.type]!.name,
            timeDiffStr(ro.nextOccurrence),
            appIcons[eventTypes[ro.reminder.type]!.icon]!))
        .toList();
  }
}

class PlantReminderInfoWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const PlantReminderInfoWidget(this.title, this.value, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: const Color.fromARGB(90, 255, 255, 255),
      strokeWidth: 1,
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      dashPattern: const [5],
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(width: 20),
            Expanded(
              // just to make the 2 TextOverflow.ellipsis work
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
