import 'package:flutter/material.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/more/reminder/edit_reminder.dart';
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
    final Color eventColor = eventType.color != null
        ? adaptiveColor(context, hexToColor(eventType.color!))
        : adaptiveColor(context, Theme.of(context).colorScheme.primary);
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () => navigateTo(context,
              EditReminderPage(widget.env, widget.reminderOccurrence.reminder)),
          child: Container(
            decoration: BoxDecoration(
              color: eventColor.withAlpha(150),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: eventColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Text(timeDiffStr(
                                widget.reminderOccurrence.nextOccurrence)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          plant.name,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text("Frequency: ",
                                style: TextStyle(fontWeight: FontWeight.w300)),
                            Text(
                              "every ${widget.reminderOccurrence.reminder.frequencyQuantity} ${widget.reminderOccurrence.reminder.frequencyUnit.name}",
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Event type: ",
                                style: TextStyle(fontWeight: FontWeight.w300)),
                            Text(
                              eventType.name,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: eventColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Icon(appIcons[eventType.icon!]),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
