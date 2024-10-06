import 'package:flutter/material.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/reminder_dto.dart';
import 'package:plant_it/dto/reminder_occurrence.dart';

class ReminderList extends StatelessWidget {
  final List<ReminderOccurrenceDTO> occurrences;
  const ReminderList({super.key, required this.occurrences});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: occurrences
            .map((e) => _ReminderOccurenceCard(
                  occurrence: e,
                ))
            .toList(),
      ),
    );
  }
}

class _ReminderOccurenceCard extends StatelessWidget {
  final ReminderOccurrenceDTO occurrence;
  const _ReminderOccurenceCard({required this.occurrence});

  String _formatFrequency(FrequencyDTO frequency) {
    return "every ${frequency.quantity} ${frequency.unit.toString().split('.').last.toLowerCase()}";
  }

  String formatDate(DateTime toFormat) {
    return '${toFormat.day.toString().padLeft(2, '0')}/${toFormat.month.toString().padLeft(2, '0')}/${toFormat.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 6,
        color: typeColors[occurrence.reminderAction],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      occurrence.reminderTargetInfoPersonalName!,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _formatFrequency(occurrence.reminderFrequency!),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 180, 180, 180),
                      ),
                    )
                  ],
                ),
              ),
              Opacity(
                opacity: .5,
                child: Icon(
                  typeIcons[occurrence.reminderAction],
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
