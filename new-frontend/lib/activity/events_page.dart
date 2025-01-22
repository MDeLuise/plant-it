import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/activity/activity_filter.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/events/event_card.dart';
import 'package:plant_it/reminder/reminder_occurrence_card.dart';
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
  Map<DateTime, List> _activityMap = {};
  List<dynamic> _activityList = [];
  List<int>? filteredPlantIds;
  List<int>? filteredEventTypeIds;
  ActivityFilterType? activityFilterType;

  List<dynamic> getActivityOfSelectedDay() {
    return _activityList.where((a) {
      if (a is Event) {
        return isSameDay(a.date, _selectedDay);
      } else {
        return isSameDay(a.nextOccurrence, _selectedDay);
      }
    }).toList();
  }

  bool isFilterActive() {
    return filteredPlantIds != null ||
        filteredEventTypeIds != null ||
        activityFilterType != null;
  }

  Future<void> _updateStateForMonth(DateTime month, List<int>? plantIds,
      List<int>? eventTypeIds, ActivityFilterType? activityType) async {
    // Fetch all events and reminders for the visible month

    List<dynamic> activity = [];
    if (activityType == null || activityType == ActivityFilterType.events) {
      activity.addAll(await widget.env.eventRepository
          .getByMonth(month, plantIds, eventTypeIds));
    }
    if (activityType == null || activityType == ActivityFilterType.reminders) {
      activity.addAll(await ReminderOccurrenceService(widget.env)
          .getForMonth(month, plantIds, eventTypeIds));
    }

    // Group events and reminders by day
    Map<DateTime, List> newActivityMap = {};
    for (var activity in activity) {
      if (activity is Event) {
        DateTime eventDate = DateTime(
            activity.date.year, activity.date.month, activity.date.day);
        newActivityMap[eventDate] = (newActivityMap[eventDate] ?? [])
          ..add(activity);
      } else {
        DateTime reminderDate = DateTime(activity.nextOccurrence.year,
            activity.nextOccurrence.month, activity.nextOccurrence.day);
        newActivityMap[reminderDate] = (newActivityMap[reminderDate] ?? [])
          ..add(activity);
      }
    }

    setState(() {
      _focusedDay = month;
      _activityMap = newActivityMap;
      _activityList = activity;
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

  void _showFilterDialog() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ActivityFilter(widget.env,
            ((plantIds, eventTypeIds, activityType) {
          filteredPlantIds = plantIds;
          filteredEventTypeIds = eventTypeIds;
          activityFilterType = activityType;
          _updateStateForMonth(_focusedDay, filteredPlantIds,
              filteredEventTypeIds, activityType);
        }), filteredPlantIds, filteredEventTypeIds, activityFilterType);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _updateStateForMonth(
        _focusedDay, filteredPlantIds, filteredEventTypeIds, null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity"),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: _showFilterDialog,
                icon: const Icon(LucideIcons.filter),
              ),
              if (isFilterActive())
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
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
                  _updateStateForMonth(focusedDay, filteredPlantIds,
                      filteredEventTypeIds, activityFilterType);
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                eventLoader: (day) {
                  List<dynamic> dayActivity =
                      _activityMap[DateTime(day.year, day.month, day.day)] ??
                          [];
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
                getActivityOfSelectedDay(),
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
  final List<dynamic> activity;
  final Environment env;

  const ListOfActivity(this.env, this.activity, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> activityWidgets = activity.map((a) {
      if (a is Event) {
        return EventCard(env, a);
      } else {
        return ReminderOccurrenceCard(env, a);
      }
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: activityWidgets,
      ),
    );
  }
}
