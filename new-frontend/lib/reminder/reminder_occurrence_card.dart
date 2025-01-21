import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/reminder/reminder_occurrence.dart';

class ReminderOccurrenceCard extends StatefulWidget {
  final Environment env;
  final ReminderOccurrence reminderOccurrence;

  const ReminderOccurrenceCard(this.env, this.reminderOccurrence, {super.key});

  @override
  State<ReminderOccurrenceCard> createState() => _ReminderOccurrenceCardState();
}

class _ReminderOccurrenceCardState extends State<ReminderOccurrenceCard> {
  late final EventType eventType;
  late final Plant plant;

  @override
  void initState() {
    super.initState();
    widget.env.eventTypeRepository
        .get(widget.reminderOccurrence.reminder.type)
        .then((r) => setState(() => eventType = r));
    widget.env.plantRepository
        .get(widget.reminderOccurrence.reminder.plant)
        .then((r) => setState(() => plant = r));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          // onTap: () =>
          //     navigateTo(context, EditReminderScreen(widget.env, widget.event)),
          child: DottedBorder(
            color: const Color.fromARGB(90, 255, 255, 255),
            strokeWidth: 1,
            borderType: BorderType.RRect,
            radius: const Radius.circular(20),
            dashPattern: const [5],
            child: Container(
              decoration: BoxDecoration(
                color: eventType.color != null
                    ? hexToColor(eventType.color!).withOpacity(.7)
                    : Theme.of(context).colorScheme.primary.withOpacity(.7),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(appIcons[eventType.icon!]),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(formatDate(
                                widget.reminderOccurrence.nextOccurrence)),
                            Text(plant.name),
                          ],
                        ),
                      ],
                    ),
                    Row(children: [
                      Text(timeDiffStr(
                          widget.reminderOccurrence.nextOccurrence)),
                      const SizedBox(width: 10),
                      const Icon(LucideIcons.bell),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
