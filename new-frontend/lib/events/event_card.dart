import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/events/edit_event.dart';
import 'package:plant_it/icons.dart';

class EventCard extends StatefulWidget {
  final Environment env;
  final Event event;

  const EventCard(this.env, this.event, {super.key});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  late final EventType eventType;
  late final Plant plant;

  @override
  void initState() {
    super.initState();
    widget.env.eventTypeRepository
        .get(widget.event.type)
        .then((r) => setState(() => eventType = r));
    widget.env.plantRepository
        .get(widget.event.plant)
        .then((r) => setState(() => plant = r));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () =>
              navigateTo(context, EditEventScreen(widget.env, widget.event)),
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
                          Text(formatDate(widget.event.date)),
                          Text(plant.name),
                        ],
                      ),
                    ],
                  ),
                  Row(children: [
                    Text(timeDiffStr(widget.event.date)),
                    const SizedBox(width: 10),
                    const Icon(LucideIcons.check),
                  ]),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
