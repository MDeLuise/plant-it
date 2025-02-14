import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
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
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: .5,
          minChildSize: .3,
          maxChildSize: .9,
          expand: false,
          builder: (context, scrollController) {
            return ActivityFilter(
              widget.env,
              (plantIds, eventTypeIds, activityType) {
                filteredPlantIds = plantIds;
                filteredEventTypeIds = eventTypeIds;
                activityFilterType = activityType;
                _updateStateForMonth(
                  _focusedDay,
                  filteredPlantIds,
                  filteredEventTypeIds,
                  activityType,
                );
              },
              filteredPlantIds,
              filteredEventTypeIds,
              activityFilterType,
              scrollController: scrollController,
            );
          },
        );
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
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 30),
            _CustomHeader(
              month: _focusedDay,
              onPreviousMonth: () {
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
                });
                _updateStateForMonth(_focusedDay, filteredPlantIds,
                    filteredEventTypeIds, activityFilterType);
              },
              onNextMonth: () {
                setState(() {
                  _focusedDay =
                      DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
                });
                _updateStateForMonth(_focusedDay, filteredPlantIds,
                    filteredEventTypeIds, activityFilterType);
              },
              showFilterDialog: _showFilterDialog,
              isFilterActive: isFilterActive(),
            ),
            const SizedBox(height: 5),
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
                    _activityMap[DateTime(day.year, day.month, day.day)] ?? [];
                return dayActivity.isEmpty ? [] : [1];
              },
              availableCalendarFormats: const {CalendarFormat.month: 'Month'},
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withAlpha(150),
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withAlpha(200),
                  shape: BoxShape.circle,
                ),
              ),
              headerVisible: false,
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
    );
  }
}

class _CustomHeader extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback showFilterDialog;
  final bool isFilterActive;

  const _CustomHeader({
    required this.month,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.showFilterDialog,
    required this.isFilterActive,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedMonth = DateFormat('MMMM yyyy').format(month);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: Icon(
            LucideIcons.chevron_left,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          formattedMonth,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: Icon(
            LucideIcons.chevron_right,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        // IconButton(
        //     onPressed: showFilterDialog,
        //     icon: const Icon(LucideIcons.list_filter)),
        Stack(
          children: [
            IconButton(
              onPressed: showFilterDialog,
              icon: Icon(
                LucideIcons.filter,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (isFilterActive)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ],
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
        return Column(
          children: [
            EventCard(env, a),
            const SizedBox(height: 10),
          ],
        );
      } else {
        return Column(
          children: [
            ReminderOccurrenceCard(env, a),
            const SizedBox(height: 10),
          ],
        );
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
