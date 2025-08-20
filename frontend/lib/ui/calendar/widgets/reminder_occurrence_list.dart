import 'package:flutter/material.dart';
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/core/themes/colors.dart';
import 'package:plant_it/ui/core/ui/reminder_occurrence_card.dart';

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
    List<ReminderOccurrence>? reminderOccurrencesForDay =
        viewModel.reminderOccurrencesForMonth[day.day];
    return Column(
      children: List.generate(
        reminderOccurrencesForDay != null
            ? reminderOccurrencesForDay.length * 2 - 1
            : 0,
        (index) {
          if (index.isEven) {
            final ReminderOccurrence ro =
                reminderOccurrencesForDay![index ~/ 2];
            return ReminderOccurrenceCard(reminderOccurrence: ro);
          } else {
            return const Divider(
                height: 16, thickness: 1, color: AppColors.grey1);
          }
        },
      ),
    );
  }
}
