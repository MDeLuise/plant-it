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

    const Map<String, Color> typeColors = {
      'SEEDING': Color.fromRGBO(23, 122, 105, 1),
      'WATERING': Color.fromARGB(255, 55, 91, 159),
      'FERTILIZING': Color.fromARGB(255, 199, 26, 24),
      'BIOSTIMULATING': Color.fromARGB(255, 203, 106, 32),
      'MISTING': Color.fromRGBO(0, 62, 185, 0.4),
      'TRANSPLANTING': Color.fromARGB(255, 175, 118, 89),
      'WATER_CHANGING': Color.fromRGBO(40, 108, 169, 1),
      'OBSERVATION': Color.fromRGBO(105, 105, 105, 1),
      'TREATMENT': Color.fromRGBO(185, 23, 50, 1),
      'PROPAGATING': Color.fromRGBO(17, 96, 50, 1),
      'PRUNING': Color.fromARGB(102, 62, 6, 183),
      'REPOTTING': Color.fromRGBO(144, 85, 67, 1),
    };

    if (typeColors.containsKey(action)) {
      backgroundColor = typeColors[action]!;
    }

    final timePassed = DateTime.now().difference(date);
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final formattedTimePassed = _formatTimePassed(context, timePassed);

    IconData actionIcon = Icons.info; // Default icon
    final Map<String, IconData> typeIcons = {
      'SEEDING': Icons.grass_outlined,
      'WATERING': Icons.water_drop_outlined,
      'FERTILIZING': Icons.lunch_dining_outlined,
      'BIOSTIMULATING': Icons.battery_charging_full_outlined,
      'MISTING': Icons.shower_outlined,
      'TRANSPLANTING': Icons.add_home_outlined,
      'WATER_CHANGING': Icons.waves_outlined,
      'OBSERVATION': Icons.visibility_outlined,
      'TREATMENT': Icons.science_outlined,
      'PROPAGATING': Icons.child_friendly_outlined,
      'PRUNING': Icons.cut_outlined,
      'REPOTTING': Icons.cached_outlined,
    };

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