import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/dto/event_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/event/event_card.dart';
import 'package:plant_it/change_notifiers.dart';
import 'package:plant_it/theme.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecentEvents extends StatefulWidget {
  final Environment env;
  const RecentEvents({
    super.key,
    required this.env,
  });

  @override
  State<StatefulWidget> createState() => _RecentEventsState();
}

class _RecentEventsState extends State<RecentEvents> {
  final int _pageSize = 5;
  bool _isLoading = true;
  List<Widget> _recentEvents = [];

  @override
  void initState() {
    super.initState();
    Provider.of<EventsNotifier>(context, listen: false).addListener(() {
      _fetchRecentEvents();
    });
    _fetchRecentEvents();
  }

  Future<void> _fetchRecentEvents() async {
    _createDummyEventSkeletons();
    final response =
        await widget.env.http.get("diary/entry?pageNo=0&pageSize=$_pageSize");
    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> entries = responseBody["content"];
      List<EventCard> newEvents = [];
      if (entries.isNotEmpty) {
        newEvents = entries.map((entry) {
          return EventCard(
            action: entry["type"],
            plant: entry["diaryTargetPersonalName"],
            date: DateTime.parse(entry["date"]),
            eventDTO: EventDTO.fromJson(entry),
            env: widget.env,
          );
        }).toList();
      }
      setState(() {
        _recentEvents = newEvents;
        _isLoading = false;
      });
    } else {
      widget.env.logger.error("Failed to load events");
      throw AppException('Failed to load events');
    }
  }

  void _createDummyEventSkeletons() {
    _isLoading = true;
    _recentEvents = List.generate(
      _pageSize,
      (index) => Skeletonizer(
        enabled: _isLoading,
        effect: skeletonizerEffect,
        child: EventCard(
          action: "",
          plant: "",
          date: DateTime.now(),
          eventDTO: EventDTO(
            date: DateTime.now(),
            diaryId: 42,
            type: "42",
          ),
          env: widget.env,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            AppLocalizations.of(context).recents,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _recentEvents,
        )
      ],
    );
  }
}
