import 'package:flutter/material.dart';
import 'package:plant_it/utils/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/utils/icons.dart';

class EventTypeAvatar extends StatelessWidget {
  final EventType eventType;
  final double? size;
  final double? iconSize;

  const EventTypeAvatar({
    super.key,
    required this.eventType,
    this.size = 20,
    this.iconSize = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Container(
        decoration: BoxDecoration(
          color: eventType.color != null
              ? hexToColor(eventType.color!)
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          appIcons[eventType.icon],
          color: Theme.of(context).colorScheme.surfaceDim,
          size: iconSize,
        ),
      ),
    );
  }
}
