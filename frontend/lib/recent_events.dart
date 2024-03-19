import 'package:flutter/material.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/events.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecentEvents extends StatefulWidget {
  final List<EventCard> recent;

  const RecentEvents({super.key, required this.recent});

  @override
  State<StatefulWidget> createState() => _RecentEvents();
}

class _RecentEvents extends State<RecentEvents> {
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
      children: widget.recent,
    );
  }

  Widget _buildGridView(BuildContext context) {
    return SizedBox(
      height: 400,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2,
        children: widget.recent,
      ),
    );
  }
}
