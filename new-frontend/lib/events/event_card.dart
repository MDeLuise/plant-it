import 'package:flutter/material.dart';
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
    final Color eventColor = eventType.color != null
        ? adaptiveColor(context, hexToColor(eventType.color!))
        : adaptiveColor(context, Theme.of(context).primaryColor);
    return Column(
      children: [
        GestureDetector(
          onTap: () =>
              navigateTo(context, EditEventScreen(widget.env, widget.event)),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plant.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${formatDate(widget.event.date)} (${timeDiffStr(widget.event.date)})",
                            style: const TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: eventColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(appIcons[eventType.icon!]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
