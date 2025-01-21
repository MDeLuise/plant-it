import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/events/event_card.dart';
import 'package:plant_it/reminder/reminder_occurrence_card.dart';
import 'package:plant_it/reminder/reminder_occurrence.dart';
import 'package:plant_it/reminder/reminder_occurrence_service.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsPage extends StatefulWidget {
  final Environment env;
  const EventsPage(this.env, {super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<ReminderOccurrence> _allRemindersOccurrences = [];
  List<Event> _allEvents = [];
  Map<DateTime, List> _eventsMap = {};

  // Filter reminders and events for the selected day
  List<ReminderOccurrence> get _filteredRemindersOccurrences {
    return _allRemindersOccurrences
        .where((r) => isSameDay(r.nextOccurrence, _selectedDay))
        .toList();
  }

  List<Event> get _filteredEvents {
    return _allEvents.where((e) => isSameDay(e.date, _selectedDay)).toList();
  }

  Future<void> _updateStateForMonth(DateTime month) async {
    // Fetch all events and reminders for the visible month
    List<Event> newEvents = await widget.env.eventRepository.getByMonth(month);
    List<ReminderOccurrence> newRemindersOccurrences =
        await ReminderOccurrenceService(widget.env).getForMonth(month);

    // Group events and reminders by day
    Map<DateTime, List> newEventsMap = {};
    for (var event in newEvents) {
      DateTime eventDate =
          DateTime(event.date.year, event.date.month, event.date.day);
      newEventsMap[eventDate] = (newEventsMap[eventDate] ?? [])..add(event);
    }

    for (var reminder in newRemindersOccurrences) {
      DateTime reminderDate = DateTime(reminder.nextOccurrence.year,
          reminder.nextOccurrence.month, reminder.nextOccurrence.day);
      newEventsMap[reminderDate] = (newEventsMap[reminderDate] ?? [])
        ..add(reminder);
    }

    setState(() {
      _focusedDay = month;
      _allEvents = newEvents;
      _allRemindersOccurrences = newRemindersOccurrences;
      _eventsMap = newEventsMap;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateStateForMonth(_focusedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(LucideIcons.filter)),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2100, 1, 1),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: _onDaySelected,
                onPageChanged: (focusedDay) {
                  _updateStateForMonth(focusedDay);
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                eventLoader: (day) {
                  // return _eventsMap[DateTime(day.year, day.month, day.day)] ??
                  //     [];
                  List<dynamic> dayActivity =
                      _eventsMap[DateTime(day.year, day.month, day.day)] ?? [];
                  return dayActivity.isEmpty ? [] : [1];
                },
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(50),
                )),
              ),
              const SizedBox(height: 40),
              ListOfActivity(
                widget.env,
                _filteredEvents,
                _filteredRemindersOccurrences,
                key: UniqueKey(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListOfActivity extends StatelessWidget {
  final List<Event> events;
  final List<ReminderOccurrence> remindersOccurrences;
  final Environment env;

  const ListOfActivity(this.env, this.events, this.remindersOccurrences,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> activityWidgets = [];
    activityWidgets.addAll(remindersOccurrences.map((r) {
      return ReminderOccurrenceCard(env, r);
    }));
    activityWidgets.addAll(events.map((e) {
      return EventCard(env, e);
    }));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: activityWidgets,
      ),
    );
  }
}
