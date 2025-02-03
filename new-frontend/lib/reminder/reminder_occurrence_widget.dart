import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/more/reminder/edit_reminder.dart';
import 'package:plant_it/reminder/reminder_occurrence.dart';

class ReminderOccurrenceWidget extends StatefulWidget {
  final Environment env;
  final ReminderOccurrence reminderOccurrence;

  const ReminderOccurrenceWidget(this.env, this.reminderOccurrence,
      {super.key});

  @override
  State<ReminderOccurrenceWidget> createState() =>
      _ReminderOccurrenceWidgetState();
}

class _ReminderOccurrenceWidgetState extends State<ReminderOccurrenceWidget> {
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

  Color _desaturate(Color color, double factor) {
    final hslColor = HSLColor.fromColor(color);
    final newSaturation = (hslColor.saturation * factor).clamp(0.0, 1.0);
    return hslColor.withSaturation(newSaturation).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => navigateTo(context,
              EditReminderPage(widget.env, widget.reminderOccurrence.reminder)),
          child: DottedBorder(
            color: const Color.fromARGB(90, 255, 255, 255),
            strokeWidth: 1,
            borderType: BorderType.RRect,
            radius: const Radius.circular(20),
            dashPattern: const [5],
            child: Container(
              decoration: BoxDecoration(
                color: eventType.color != null
                    ? _desaturate(hexToColor(eventType.color!), .6)
                    : _desaturate(Theme.of(context).colorScheme.primary, .6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${eventType.name} Reminder",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                          "Don't forget to ${eventType.name} your ${plant.name} every ${widget.reminderOccurrence.reminder.frequencyQuantity} ${widget.reminderOccurrence.reminder.frequencyUnit.name}."),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .45,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(5),
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
        ),
      ],
    );
  }
}
