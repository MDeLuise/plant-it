import 'package:flutter/material.dart';
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:plant_it/ui/core/themes/colors.dart';
import 'package:plant_it/ui/core/ui/reminder_occurrence_card.dart';
import 'package:plant_it/ui/home/view_models/home_viewmodel.dart';

class ReminderOccurrenceList extends StatelessWidget {
  final HomeViewModel viewModel;
  const ReminderOccurrenceList({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        viewModel.reminderOccurrences.length * 2 - 1,
        (index) {
          if (index.isEven) {
            final ReminderOccurrence ro =
                viewModel.reminderOccurrences[index ~/ 2];
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
