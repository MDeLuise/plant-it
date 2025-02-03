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
    return Column(
      children: [
        GestureDetector(
          onTap: () => navigateTo(context,
              EditReminderPage(widget.env, widget.reminderOccurrence.reminder)),
          child: Container(
            decoration: BoxDecoration(
              color: eventType.color != null
                  ? adaptiveColor(context, hexToColor(eventType.color!))
                  : adaptiveColor(
                      context, Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: adaptiveColor(context,
                          Theme.of(context).colorScheme.onPrimaryContainer)
                      .withOpacity(.2),
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${eventType.name.substring(0, 1).toUpperCase()}${eventType.name.substring(1)} Reminder",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Don't forget to ${eventType.name} your ${plant.name} every ${widget.reminderOccurrence.reminder.frequencyQuantity} ${widget.reminderOccurrence.reminder.frequencyUnit.name}.",
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .45,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                appIcons[eventType.icon],
                                size: 17,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                timeDiffStr(
                                    widget.reminderOccurrence.nextOccurrence),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: 2),
                              const Text(" "),
                              Expanded(
                                child: Text(
                                  eventType.name,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
