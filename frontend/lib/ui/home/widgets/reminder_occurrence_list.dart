import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/domain/models/reminder_occurrence.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/routing/routes.dart';
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
    L appLocalizations = L.of(context);

    if (viewModel.reminderOccurrences.isEmpty) {
      return Column(
        children: [
          Text(
            appLocalizations.noReminder,
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.push(Routes.reminder),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 0,
            ),
            child: Text(appLocalizations.createReminder),
          ),
        ],
      );
    }

    return Column(
      children: List.generate(
        viewModel.reminderOccurrences.length * 2 - 1,
        (index) {
          if (index.isEven) {
            ReminderOccurrence ro = viewModel.reminderOccurrences[index ~/ 2];
            return ReminderOccurrenceCard(
              reminderOccurrence: ro,
              createEvent: viewModel.createEventFromReminder,
            );
          } else {
            return const Divider(
                height: 16, thickness: 1, color: AppColors.grey1);
          }
        },
      ),
    );
  }
}
