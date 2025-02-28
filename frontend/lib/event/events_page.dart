import 'package:flutter/material.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/event/events_done_section.dart';
import 'package:plant_it/floating_tabbar.dart';
import 'package:plant_it/event/reminder_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class EventsPage extends StatefulWidget {
  final Environment env;

  const EventsPage({super.key, required this.env});

  @override
  State<StatefulWidget> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  int _activeIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget getCurrentSection() {
      if (_activeIndex == 0) {
        return ReminderSection(env: widget.env);
      } else {
        return EventsDoneSection(env: widget.env);
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 32,
      ),
      child: Column(
        children: [
          FloatingTabBar(
            titles: [
              AppLocalizations.of(context).reminders,
              AppLocalizations.of(context).events,
              ],
            callbacks: [
              () => _onTabSelected(0),
              () => _onTabSelected(1),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: getCurrentSection(),
          ),
        ],
      ),
    );
  }
}
