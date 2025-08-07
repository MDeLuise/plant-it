import 'package:flutter/material.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/core/themes/colors.dart';
import 'package:plant_it/utils/common.dart';
import 'package:plant_it/utils/icons.dart';

class ReminderOccurrenceList extends StatelessWidget {
  final CalendarViewModel viewModel;
  final DateTime day;

  const ReminderOccurrenceList({
    super.key,
    required this.viewModel,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    List<ReminderOccurrence>? reminderOccurrencesForDay = viewModel.reminderOccurrencesForMonth[day.day];
    return Column(
      children: List.generate(
        reminderOccurrencesForDay != null ? reminderOccurrencesForDay.length * 2 - 1 : 0,
        (index) {
          if (index.isEven) {
            final ReminderOccurrence ro = reminderOccurrencesForDay![index ~/ 2];
            return _ReminderOccurrenceCard(reminderOccurrence: ro);
          } else {
            return const Divider(height: 16, thickness: 1, color: AppColors.grey1);
          }
        },
      ),
    );
  }
}

class _ReminderOccurrenceCard extends StatelessWidget {
  final ReminderOccurrence reminderOccurrence;

  const _ReminderOccurrenceCard({required this.reminderOccurrence});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(
        reminderOccurrence.plant.name,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        "${timeDiffStr(reminderOccurrence.nextOccurrence)} • every ${reminderOccurrence.reminder.frequencyQuantity} ${reminderOccurrence.reminder.frequencyUnit.name}",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: AppColors.grey4),
      ),
      leading: _EventTypeAvatar(eventType: reminderOccurrence.eventType),
      trailing: Icon(Icons.more_vert, size: 25),
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
