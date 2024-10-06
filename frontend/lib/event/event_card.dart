import 'package:flutter/material.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/event_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/event/edit_event.dart';

class EventCard extends StatelessWidget {
  final Environment env;
  final String action;
  final String plant;
  final DateTime date;
  final EventDTO eventDTO;

  const EventCard({
    super.key,
    required this.env,
    required this.action,
    required this.plant,
    required this.date,
    required this.eventDTO,
  });

  String _formatTimePassed(BuildContext context, Duration timePassed) {
    if (timePassed.inDays == 0) {
      return AppLocalizations.of(context).today;
    } else if (timePassed.inDays == 1) {
      return AppLocalizations.of(context).yesterday;
    } else if (timePassed.inDays < 30) {
      if (timePassed.inDays > 0) {
        return AppLocalizations.of(context).nDaysAgo(timePassed.inDays);
      } else {
        return AppLocalizations.of(context)
            .nDaysInFuture(timePassed.inDays.abs());
      }
    } else if (timePassed.inDays < 365) {
      final months = (timePassed.inDays / 30).floor();
      return AppLocalizations.of(context).nMonthsAgo(months);
    } else {
      final years = (timePassed.inDays / 365).floor();
      return AppLocalizations.of(context).nYearsAgo(years);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[200]!; // Default color

    if (typeColors.containsKey(action)) {
      backgroundColor = typeColors[action]!;
    }

    final timePassed = DateTime.now().difference(date);
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final formattedTimePassed = _formatTimePassed(context, timePassed);

    IconData actionIcon = Icons.info; // Default icon

    if (typeIcons.containsKey(action)) {
      actionIcon = typeIcons[action]!;
    }

    return GestureDetector(
      onTap: () => goToPageSlidingUp(
          context, EditEventPage(env: env, eventDTO: eventDTO)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 6,
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$formattedDate ($formattedTimePassed)',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 216, 216, 216)),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          plant,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(255, 180, 180, 180)),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: .5,
                      child: Icon(
                        actionIcon,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}