import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/calendar/widgets/calendar_header.dart';
import 'package:plant_it/ui/calendar/widgets/event_list.dart';
import 'package:plant_it/ui/calendar/widgets/reminder_occurrence_list.dart';
import 'package:plant_it/ui/core/ui/app_main_view.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final CalendarViewModel viewModel;

  const CalendarScreen({super.key, required this.viewModel});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return AppMainView(
      selectedIndex: 1,
      body: SafeArea(
        top: true,
        bottom: true,
        child: ValueListenableBuilder<CommandResult<void, void>>(
            valueListenable: widget.viewModel.load.results,
            builder: (context, command, _) {
              if (command.isExecuting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (command.hasError) {
                return ErrorIndicator(
                  title:
                      "Error", // AppLocalization.of(context).errorWhileLoadingHome,
                  label: "Try again", //AppLocalization.of(context).tryAgain,
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
                        context.go(Routes.calendar, extra: filteredViewModel);
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
                        List<dynamic> eventsAndReminderOccurrences = [];
                        eventsAndReminderOccurrences.addAll(
                            widget.viewModel.eventsForMonth[day.day] ?? []);
                        eventsAndReminderOccurrences.addAll(widget.viewModel
                                .reminderOccurrencesForMonth[day.day] ??
                            []);
                        return eventsAndReminderOccurrences.isEmpty ? [] : [1];
                      },
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month'
                      },
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
                    DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TabBar(tabs: [
                              Tab(text: "Actions"),
                              Tab(text: "Events"),
                            ]),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .4,
                              child: TabBarView(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      child: ReminderOccurrenceList(
                                        viewModel: widget.viewModel,
                                        day: _selectedDay,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      child: EventList(
                                        viewModel: widget.viewModel,
                                        day: _selectedDay,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              );
            }),
      ),
    );
  }
}
