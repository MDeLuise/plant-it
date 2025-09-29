import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/calendar/widgets/calendar_header.dart';
import 'package:plant_it/ui/calendar/widgets/event_and_reminder_occurrences_list.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/utils/stream_code.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final CalendarViewModel viewModel;
  final StreamController<StreamCode> streamController;

  const CalendarScreen({
    super.key,
    required this.viewModel,
    required this.streamController,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    widget.streamController.stream.listen((c) {
      List<StreamCode> eventsThatTriggerUpdate = [
        StreamCode.insertEvent,
        StreamCode.editEvent,
        StreamCode.deletePlant,
        StreamCode.insertEvent,
        StreamCode.deleteEvent,
        StreamCode.insertReminder,
        StreamCode.deleteReminder,
        StreamCode.editReminder,
      ];
      if (eventsThatTriggerUpdate.contains(c)) {
        widget.viewModel.load.execute();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: ValueListenableBuilder<CommandResult<void, void>>(
          valueListenable: widget.viewModel.filter.results,
          builder: (context, command, _) {
            if (command.isExecuting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (command.hasError) {
              return ErrorIndicator(
                title: L.of(context).errorWithMessage(command.error.toString()),
                label: L.of(context).tryAgain,
                onPressed: widget.viewModel.load.execute,
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarHeader(
                    goToFilter: () async {
                      CalendarViewModel filteredViewModel = await context.push(
                          Routes.activityFilter,
                          extra: widget.viewModel) as CalendarViewModel;
                      context.go(Routes.home, extra: filteredViewModel);
                    },
                    month: _focusedDay,
                    onPreviousMonth: () async {
                      setState(() {
                        _focusedDay = DateTime(
                            _focusedDay.year, _focusedDay.month - 1, 1);
                      });
                    },
                    onNextMonth: () async {
                      setState(() {
                        _focusedDay = DateTime(
                            _focusedDay.year, _focusedDay.month + 1, 1);
                      });
                    },
                    viewModel: widget.viewModel,
                    isFilterActive: widget.viewModel.filterActive,
                  ),
                  TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2100, 1, 1),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                    },
                    onPageChanged: (focusedDay) async {
                      await widget.viewModel.loadForMonth
                          .executeWithFuture(focusedDay);
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarFormat: _calendarFormat,
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    eventLoader: (day) {
                      bool dayHasEvents =
                          (widget.viewModel.eventsForMonth[day.day] ?? [])
                              .isNotEmpty;
                      bool dayHasReminderOccurrences = (widget.viewModel
                                  .reminderOccurrencesForMonth[day.day] ??
                              [])
                          .isNotEmpty;
                      if (dayHasEvents && dayHasReminderOccurrences) {
                        return [1, 2];
                      } else if (dayHasEvents) {
                        return [1];
                      } else if (dayHasReminderOccurrences) {
                        return [2];
                      }
                      return [];
                    },
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        List<Widget> markers = [];
                        if (events.contains(1)) {
                          markers.add(CircleAvatar(
                              radius: 5,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary));
                        }
                        if (events.contains(2)) {
                          markers.add(CircleAvatar(
                              radius: 5,
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary));
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: markers,
                        );
                      },
                    ),
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month'
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(150),
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withAlpha(200),
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerVisible: false,
                  ),
                  SizedBox(height: 10),
                  ActivityList(
                    key: UniqueKey(),
                    viewModel: widget.viewModel,
                    day: _focusedDay,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
