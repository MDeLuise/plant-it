import 'package:flutter/material.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/reminder_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewReminderSnippet extends StatelessWidget {
  final Environment env;
  final int targetId;

  const AddNewReminderSnippet({
    super.key,
    required this.env,
    required this.targetId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).addNew,
            style: TextStyle(
              color: const Color.fromARGB(255, 156, 192, 172),
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.add_outlined,
            size: 25,
            color: const Color.fromARGB(255, 156, 192, 172),
            weight: 25,
          ),
        ],
      ),
    );
  }
}

class ReminderSnippet extends StatelessWidget {
  final Environment env;
  final ReminderDTO reminder;

  const ReminderSnippet({
    super.key,
    required this.env,
    required this.reminder,
  });

  String _formatFrequency() {
    return "every ${reminder.frequency!.quantity} ${reminder.frequency!.unit.toString().split('.').last.toLowerCase()}";
  }

  String _formatDatespan() {
    String result = "${formatDate(reminder.start!)}";
    if (reminder.end != null) {
      result += "- ${formatDate(reminder.end!)}";
    } else {
      result = "from $result";
    }
    return result;
  }

  String formatDate(DateTime toFormat) {
    return '${toFormat.day.toString().padLeft(2, '0')}/${toFormat.month.toString().padLeft(2, '0')}/${toFormat.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(getLocaleEvent(context, reminder.action!)),
              Text(", "),
              Text(_formatFrequency()),
              Text(", "),
              Text(_formatDatespan()),
            ],
          ),
          Icon(
            Icons.edit_outlined,
            size: 20,
          ),
        ],
      ),
    );
  }
}
