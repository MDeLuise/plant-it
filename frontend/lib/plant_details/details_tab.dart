import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/dto/reminder_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/info_entries.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/reminders/reminder_add.dart';
import 'package:plant_it/reminders/reminder_edit.dart';
import 'package:plant_it/reminders/reminder_snippet.dart';

class DetailsTab extends StatefulWidget {
  final PlantDTO plant;
  final Environment env;

  const DetailsTab({
    super.key,
    required this.plant,
    required this.env,
  });

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> {
  int _photos = -1;
  int _events = -1;
  bool _isEventStatsLoading = true;
  late final Map<String, String> _eventsStats;
  late List<ReminderDTO> _reminders;
  bool _isRemindersLoading = true;

  void _fetchAndSetPhotosNumber() async {
    try {
      final response =
          await widget.env.http.get("image/entity/all/${widget.plant.id}");
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        if (!mounted) return;
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
      setState(() {
        _photos = responseBody.length;
      });
    } catch (e, st) {
      if (!mounted) return;
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  void _fetchAndSetEventsNumber() async {
    try {
      final response =
          await widget.env.http.get("diary/entry/${widget.plant.id}/_count");
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        if (!mounted) return;
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
      setState(() {
        _events = responseBody;
      });
    } catch (e, st) {
      if (!mounted) return;
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  void _fetchAndSetPlantStats() async {
    final Map<String, String> result = Map.fromEntries([]);
    try {
      final response =
          await widget.env.http.get("diary/entry/${widget.plant.id}/stats");
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        if (!mounted) return;
        throw AppException(responseBody["message"]);
      }
      if (!mounted) return;
      for (var stat in responseBody) {
        result.putIfAbsent(
            getLocaleEvent(context, stat["type"]),
            () => _calculateAndFormatTimePassed(
                context, DateTime.parse(stat["date"]))!);
      }
      setState(() {
        _eventsStats = result;
        _isEventStatsLoading = false;
      });
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  void _fetchAndSetPlantReminders() async {
    try {
      final response = await widget.env.http.get("reminder/${widget.plant.id}");
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        if (!mounted) return;
        throw AppException(responseBody["message"]);
      }
      if (!mounted) return;
      final List<ReminderDTO> reminders = [];
      for (var rem in responseBody) {
        reminders.add(ReminderDTO.fromJson(rem));
      }
      setState(() {
        _reminders = reminders;
        _isRemindersLoading = false;
      });
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  String? _calculateAndFormatTimePassed(
      BuildContext context, DateTime birthday) {
    final timePassed = DateTime.now().difference(birthday);
    if (timePassed.inDays == 0) {
      return AppLocalizations.of(context).today;
    } else if (timePassed.inDays == 1) {
      return AppLocalizations.of(context).yesterday;
    } else if (timePassed.inDays < 30) {
      return AppLocalizations.of(context).nDays(timePassed.inDays);
    } else if (timePassed.inDays < 365) {
      final months = timePassed.inDays ~/ 30;
      final remainingDays = timePassed.inDays % 30;
      if (remainingDays == 0) {
        return AppLocalizations.of(context).nMonths(months);
      } else {
        return AppLocalizations.of(context)
            .nMonthsAndDays(months, remainingDays);
      }
    } else {
      final years = timePassed.inDays ~/ 365;
      final remainingMonths = (timePassed.inDays % 365) ~/ 30;
      final remainingDays = (timePassed.inDays % 365) % 30;
      if (remainingMonths == 0 && remainingDays == 0) {
        return AppLocalizations.of(context).nYears(years);
      } else if (remainingMonths == 0) {
        return AppLocalizations.of(context).nYearsAndDays(years, remainingDays);
      } else if (remainingDays == 0) {
        return AppLocalizations.of(context)
            .nYearsAndMonths(years, remainingMonths);
      } else {
        return AppLocalizations.of(context)
            .nYearsAndMonthsAndDays(years, remainingMonths, remainingDays);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetPhotosNumber();
    _fetchAndSetEventsNumber();
    _fetchAndSetPlantStats();
    _fetchAndSetPlantReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        InfoGroup(
          title: AppLocalizations.of(context).eventStats,
          children: _isEventStatsLoading
              ? generateSkeleton(3, _isEventStatsLoading)
              : _eventsStats.entries.map((entry) {
                  return SimpleInfoEntry(
                    title: entry.key,
                    value: entry.value.toString(),
                  );
                }).toList(),
        ),
        InfoGroup(
            title: AppLocalizations.of(context).reminders,
            children: _isRemindersLoading
                ? generateSkeleton(3, _isRemindersLoading)
                : [
                    GestureDetector(
                      onTap: () async {
                        final bool added = await goToPageSlidingUp(
                          context,
                          AddReminder(
                            env: widget.env,
                            targetId: widget.plant.id!,
                          ),
                        );
                        if (added) {
                          _fetchAndSetPlantReminders();
                        }
                      },
                      child: AddNewReminderSnippet(
                        env: widget.env,
                        targetId: widget.plant.id!,
                      ),
                    ),
                    ..._reminders.map((r) => GestureDetector(
                          onTap: () async {
                            final bool updated = await goToPageSlidingUp(
                              context,
                              EditReminder(
                                env: widget.env,
                                reminder: r,
                              ),
                            );
                            if (updated) {
                              _fetchAndSetPlantReminders();
                            }
                          },
                          child: ReminderSnippet(
                            env: widget.env,
                            reminder: r,
                          ),
                        )),
                  ]),
        InfoGroup(
          title: AppLocalizations.of(context).stats,
          children: [
            SimpleInfoEntry(
                title: AppLocalizations.of(context).numberOfPhotos,
                value: _photos == -1 ? null : _photos.toString()),
            SimpleInfoEntry(
                title: AppLocalizations.of(context).numberOfEvents,
                value: _events == -1 ? null : _events.toString())
          ],
        ),
      ],
    );
  }
}
