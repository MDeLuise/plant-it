import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/core/themes/colors.dart';
import 'package:plant_it/utils/common.dart';
import 'package:plant_it/utils/icons.dart';

class EventList extends StatelessWidget {
  final CalendarViewModel viewModel;
  final DateTime day;

  const EventList({
    super.key,
    required this.viewModel,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    List<Event>? eventForDay = viewModel.eventsForMonth[day.day];
    return Column(
      children: List.generate(
        eventForDay != null ? eventForDay.length * 2 - 1 : 0,
        (index) {
          if (index.isEven) {
            final Event e = eventForDay![index ~/ 2];
            return _EventCard(event: e, viewModel: viewModel);
          } else {
            return const Divider(height: 16, thickness: 1, color: AppColors.grey1);
          }
        },
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
    final CalendarViewModel viewModel;

  const _EventCard({required this.event, required this.viewModel,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.eventWithId(event.id)),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        title: Text(
          viewModel.plants[event.plant]!.name,
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
        leading: _EventTypeAvatar(eventType: viewModel.eventTypes[event.type]!),
        trailing: Icon(Icons.more_vert, size: 25),
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
          MaterialShapes.fourLeafClover(
              size: size, color: hexToColor(eventType.color!)),
          Icon(appIcons[eventType.icon], size: 25, color: AppColors.black2),
        ],
      ),
    );
  }
}
