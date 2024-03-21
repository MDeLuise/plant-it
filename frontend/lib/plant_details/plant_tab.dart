import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/info_entries.dart';

class PlantDetailsTab extends StatefulWidget {
  final PlantDTO plant;
  final AppHttpClient http;
  const PlantDetailsTab({super.key, required this.plant, required this.http});

  @override
  State<StatefulWidget> createState() => _PlantDetailsTabState();
}

class _PlantDetailsTabState extends State<PlantDetailsTab> {
  late final Map<String, String> _eventsStats;
  bool _isEventStatsLoading = true;
  int _photos = -1;
  int _events = -1;
  String? _calculateAndFormatAge(BuildContext context, DateTime birthday) {
    final timePassed = DateTime.now().difference(birthday);
    if (timePassed.inDays == 0) {
      return AppLocalizations.of(context).newBorn;
    } else if (timePassed.inDays < 30) {
      if (timePassed.inDays > 0) {
        return AppLocalizations.of(context).nDays(timePassed.inDays);
      } else {
        return AppLocalizations.of(context)
            .nDaysInFuture(timePassed.inDays.abs());
      }
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

  void _fetchAndSetPhotosNumber() async {
    try {
      final response =
          await widget.http.get("image/entity/all/${widget.plant.id}");
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        showSnackbar(context, SnackBarType.fail, responseBody["message"]);
        return;
      }
      setState(() {
        _photos = responseBody.length;
      });
    } catch (e) {
      showSnackbar(context, SnackBarType.fail, e.toString());
    }
  }

  void _fetchAndSetEventsNumber() async {
    try {
      final response =
          await widget.http.get("diary/entry/${widget.plant.id}/_count");
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        showSnackbar(context, SnackBarType.fail, responseBody["message"]);
        return;
      }
      setState(() {
        _events = responseBody;
      });
    } catch (e) {
      showSnackbar(context, SnackBarType.fail, e.toString());
    }
  }

  void _fetchAndSetPlantStats() async {
    final Map<String, String> result = Map.fromEntries([]);
    try {
      final response =
          await widget.http.get("diary/entry/${widget.plant.id}/stats");
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        showSnackbar(context, SnackBarType.fail, responseBody["message"]);
        return;
      }
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
    } catch (e) {
      showSnackbar(context, SnackBarType.fail, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetPhotosNumber();
    _fetchAndSetEventsNumber();
    _fetchAndSetPlantStats();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          InfoGroup(
            title: AppLocalizations.of(context).info,
            children: [
              SimpleInfoEntry(
                  title: AppLocalizations.of(context).name,
                  value: widget.plant.info.personalName),
              SimpleInfoEntry(
                  title: AppLocalizations.of(context).birthday,
                  value: widget.plant.info.startDate != null
                      ? formatDate(DateTime.parse(widget.plant.info.startDate!))
                      : null),
              SimpleInfoEntry(
                  title: AppLocalizations.of(context).age,
                  value: widget.plant.info.startDate != null
                      ? _calculateAndFormatAge(
                          context, DateTime.parse(widget.plant.info.startDate!))
                      : null),
              SimpleInfoEntry(
                  title: AppLocalizations.of(context).avatar,
                  value: widget.plant.avatarMode),
              FullWidthInfoEntry(
                title: AppLocalizations.of(context).note,
                value: widget.plant.info.note,
              ),
              SimpleInfoEntry(
                  title: AppLocalizations.of(context).purchasedPrice,
                  value: widget.plant.info.purchasedPrice == null
                      ? null
                      : (widget.plant.info.purchasedPrice!.toString() +
                          (widget.plant.info.currencySymbol ?? ""))),
              SimpleInfoEntry(
                  title: AppLocalizations.of(context).seller,
                  value: widget.plant.info.seller.toString()),
              SimpleInfoEntry(
                  title: AppLocalizations.of(context).location,
                  value: widget.plant.info.location.toString()),
            ],
          ),
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
          )
        ],
      ),
    );
  }
}
