import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/events.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RecentEvents extends StatefulWidget {
  final Environment env;
  const RecentEvents({super.key, required this.env});

  @override
  State<StatefulWidget> createState() => _RecentEvents();
}

class _RecentEvents extends State<RecentEvents> {
  final int _pageSize = 5;
  bool _isLoading = true;
  List<Widget> _recentEvents = List.empty();

  @override
  void initState() {
    _recentEvents = _createDummyEventSkeletons();
    _fetchRecentEvents().then((actualRecentEvents) {
      setState(() {
        _recentEvents = actualRecentEvents;
        _isLoading = false;
      });
    });
    super.initState();
  }

  Future<List<EventCard>> _fetchRecentEvents() async {
    final response =
        await widget.env.http.get("diary/entry?pageNo=0&pageSize=$_pageSize");
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<dynamic> entries = responseBody["content"];
      _isLoading = false;
      return entries.map((entry) {
        return EventCard(
          action: entry["type"],
          plant: entry["diaryTargetPersonalName"],
          date: DateTime.parse(entry["date"]),
        );
      }).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  List<Skeletonizer> _createDummyEventSkeletons() {
    return List.generate(
        _pageSize,
        (index) => Skeletonizer(
            enabled: _isLoading,
            effect: const PulseEffect(
              from: Colors.grey,
              to: Color.fromARGB(255, 207, 207, 207),
            ),
            child: EventCard(
              action: "",
              plant: "",
              date: DateTime.now(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (isSmallScreen(context)) {
      body = _buildListView(context);
    } else {
      body = _buildGridView(context);
    }
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
        body
      ],
    );
  }

  Widget _buildListView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _recentEvents,
    );
  }

  Widget _buildGridView(BuildContext context) {
    return SizedBox(
      height: 400,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2,
        children: _recentEvents,
      ),
    );
  }
}
