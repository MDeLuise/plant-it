import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_stack/avatar_stack.dart';
import 'package:avatar_stack/positions.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/reminder_dto.dart';
import 'package:plant_it/dto/reminder_occurrence.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/event/reminder_list.dart';
import 'package:plant_it/events_notifier.dart';
import 'package:provider/provider.dart';

class ReminderSection extends StatefulWidget {
  final Environment env;
  const ReminderSection({super.key, required this.env});

  @override
  State<StatefulWidget> createState() => _ReminderSectionState();
}

class _ReminderSectionState extends State<ReminderSection> {
  final GlobalKey<MonthViewState> _globalKey = GlobalKey<MonthViewState>();
  final EventController _eventController = EventController();
  late final DateTime _lastStartMonthDateFetched;

  Widget _getDayOfWeek(int day) {
    final now = DateTime.now();
    final date = now.add(Duration(days: (day - now.weekday + 7) % 7 + 1));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.grey,
        ),
        child: Center(
          child: AutoSizeText(
            DateFormat.E(Localizations.localeOf(context).toLanguageTag())
                .format(date)
                .toUpperCase(),
            maxLines: 1,
          ),
        ),
      ),
    );
  }

  Row getHeader(BuildContext context, DateTime date) {
    final String monthName =
        DateFormat.MMMM(Localizations.localeOf(context).toLanguageTag())
            .format(date);
    final String monthNameCapitalized =
        "${monthName[0].toUpperCase()}${monthName.substring(1).toLowerCase()}";

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: AutoSizeText(
            "$monthNameCapitalized, ${date.year}",
            style: const TextStyle(fontSize: 40),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () => _globalKey.currentState!.previousPage(),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            IconButton(
              onPressed: () => _globalKey.currentState!.nextPage(),
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ],
    );
  }

  void _fetchReminderOccurrences(DateTime startMonthDate) async {
    final String startDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(startMonthDate);
    final String endDate = _getEndMonthDate(startMonthDate);
    final response = await widget.env.http.get(
        "reminder/occurrences?from=$startDate&to=$endDate&page=0&size=1000");
    if (response.statusCode != 200) {
      widget.env.logger.error("Failed to load reminders");
      throw AppException('Failed to load reminders');
    }

    final responseBody = json.decode(response.body);
    final List<CalendarEventData> toAdd = [];
    for (var element in responseBody["content"]) {
      toAdd.add(CalendarEventData(
        title: "",
        date: DateTime.parse(element["date"]),
        event: ReminderOccurrenceDTO(
          reminderAction: element["reminderAction"],
          reminderTargetInfoPersonalName:
              element["reminderTargetInfoPersonalName"],
          reminderFrequency:
              FrequencyDTO.fromJson(element["reminderFrequency"]),
        ),
      ));
    }
    _eventController.removeWhere((e) => !toAdd.contains(e));
    _eventController.addAll(toAdd);
    _lastStartMonthDateFetched = startMonthDate;
  }

  String _getEndMonthDate(DateTime startMonthDate) {
    final DateTime nextMonth =
        DateTime(startMonthDate.year, startMonthDate.month + 1, 1);
    final DateTime lastDayOfMonth = nextMonth.subtract(const Duration(days: 1));
    final DateTime lastDayEndTime = DateTime(lastDayOfMonth.year,
        lastDayOfMonth.month, lastDayOfMonth.day, 23, 59, 59);
    final String formattedDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(lastDayEndTime);
    return formattedDate;
  }

  DateTime _getStartMonthDate(DateTime date) {
    final DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    final DateTime firstDayStartTime = DateTime(firstDayOfMonth.year,
        firstDayOfMonth.month, firstDayOfMonth.day, 0, 0, 0);
    return firstDayStartTime;
  }

  void _showDayDialog(List<CalendarEventData<Object?>> events, DateTime date) {
    final List<ReminderOccurrenceDTO> occurrences =
        events.map((e) => e.event as ReminderOccurrenceDTO).toList();
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
                maxHeight: 400,
              ),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEE, MMM dd',
                              Localizations.localeOf(context).toLanguageTag())
                          .format(date)
                          .toUpperCase(),
                      style: TextStyle(
                        color:
                            Color.fromARGB(255, 180, 180, 180).withOpacity(.5),
                      ),
                    ),
                    ReminderList(
                      occurrences: occurrences,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _lastStartMonthDateFetched = _getStartMonthDate(DateTime.now());
    _fetchReminderOccurrences(_lastStartMonthDateFetched);
    Provider.of<EventsNotifier>(context, listen: false).addListener(() {
      _fetchReminderOccurrences(_getStartMonthDate(_lastStartMonthDateFetched));
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: _eventController,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: MonthView(
          key: _globalKey,
          cellAspectRatio: 1,
          showBorder: false,
          onPageChange: (date, page) => _fetchReminderOccurrences(date),
          cellBuilder: (date, event, isToday, isInMonth, hideDaysNotInMonth) =>
              Padding(
            padding: const EdgeInsets.all(5.0),
            child: isInMonth
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: const Color.fromRGBO(24, 44, 37, 1),
                      border: isToday
                          ? Border.all(
                              color: const Color.fromRGBO(76, 175, 80, 1),
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (event.isNotEmpty)
                          _ReminderOccurrenceStack(
                            reminderOccurrenceDTOs: event
                                .map((e) => e.event as ReminderOccurrenceDTO)
                                .toList(),
                          ),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: isReallySmallScreen(context)
                                ? 10
                                : isSmallScreen(context)
                                    ? 10
                                    : 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : null,
          ),
          headerBuilder: (date) => getHeader(context, date),
          weekDayBuilder: _getDayOfWeek,
          onCellTap: (events, date) {
            if (events.isEmpty) {
              return;
            }
            _showDayDialog(events, date);
          },
        ),
      ),
    );
  }
}

class _ReminderOccurrenceCard extends StatelessWidget {
  final ReminderOccurrenceDTO reminderOccurrenceDTO;

  const _ReminderOccurrenceCard({required this.reminderOccurrenceDTO});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth * .7;
        final double iconSize = width * .8;
        return Container(
          width: width,
          height: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: typeColors[reminderOccurrenceDTO.reminderAction],
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: Icon(
                typeIcons[reminderOccurrenceDTO.reminderAction],
                size: iconSize,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReminderOccurrenceStack extends StatelessWidget {
  final List<ReminderOccurrenceDTO> reminderOccurrenceDTOs;

  const _ReminderOccurrenceStack({required this.reminderOccurrenceDTOs});

  @override
  Widget build(BuildContext context) {
    final List<_ReminderOccurrenceCard> avatars = reminderOccurrenceDTOs
        .map((e) => _ReminderOccurrenceCard(
              reminderOccurrenceDTO: e,
            ))
        .toList();
    return SizedBox(
      height: isReallySmallScreen(context)
          ? 20
          : isSmallScreen(context)
              ? 24
              : 34,
      child: WidgetStack(
        positions: RestrictedPositions(
          maxCoverage: .4,
          minCoverage: .4,
          align: StackAlign.center,
        ),
        buildInfoWidget: (surplus) {
          return Center(
              child: Text(
            '+$surplus',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ));
        },
        stackedWidgets: avatars,
      ),
    );
  }
}
