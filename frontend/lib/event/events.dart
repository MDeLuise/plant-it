import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/event/event_card.dart';
import 'package:plant_it/events_notifier.dart';
import 'package:provider/provider.dart';

import '../dropdown.dart';

class FilterWidget extends StatefulWidget {
  final Environment env;
  final Function(List<String>) onSelectedEventsChanged;
  final Function(List<String>) onSelectedPlantsChanged;

  const FilterWidget(
      {super.key,
      required this.env,
      required this.onSelectedEventsChanged,
      required this.onSelectedPlantsChanged});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isOpen = !_isOpen;
              });
            },
            child: Row(
              children: [
                Text(
                  AppLocalizations.of(context).filter,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Icon(
                  _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
          if (_isOpen) ...[
            const SizedBox(height: 16.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldMultipleDropDown(
                  onSelectedItemsChanged: widget.onSelectedPlantsChanged,
                  options: widget.env.plants
                      .map((e) => e.info.personalName!)
                      .toList(),
                  text: AppLocalizations.of(context).plants,
                ),
                const SizedBox(height: 10),
                TextFieldMultipleDropDown(
                  onSelectedItemsChanged: widget.onSelectedEventsChanged,
                  options: widget.env.eventTypes
                      .map((e) => getLocaleEvent(context, e))
                      .toList(),
                  text: AppLocalizations.of(context).events,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class EventsPage extends StatefulWidget {
  final Environment env;
  const EventsPage({super.key, required this.env});

  @override
  State<StatefulWidget> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final _pageSize = 10;
  final PagingController<int, EventCard> _pagingController =
      PagingController(firstPageKey: 0);
  List<String> _selectedPlants = [];
  List<String> _selectedEventTypes = [];

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    Provider.of<EventsNotifier>(context, listen: false).addListener(() {
      _pagingController.refresh();
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final int pageToFetch = (pageKey / _pageSize).floor();
      final newItems = await _getEventsPage(pageToFetch);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
      widget.env.logger.error(error);
    }
  }

  Future<List<EventCard>> _getEventsPage(int pageNo) async {
    String url = "diary/entry?pageNo=$pageNo&pageSize=$_pageSize";
    if (_selectedEventTypes.isNotEmpty) {
      url +=
          "&eventTypes=${_selectedEventTypes.map((e) => encodeEventType(e)).join(',')}";
    }
    if (_selectedPlants.isNotEmpty) {
      final List<int> selectedPlantIds = widget.env.plants
          .where((p) => _selectedPlants.contains(p.info.personalName))
          .map((p) => p.id!)
          .toList();
      url += "&plantIds=${selectedPlantIds.join(',')}";
    }
    final response = await widget.env.http.get(url);
    if (response.statusCode == 200) {
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> entries = responseBody["content"];
      return entries.map((entry) => dtoToCard(entry, widget.env)).toList();
    } else {
      widget.env.logger.error("Failed to load events");
      throw AppException('Failed to load events');
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: FilterWidget(
            onSelectedEventsChanged: (x) {
              _selectedEventTypes =
                  x.map((e) => getBackendEvent(context, e)).toList();
              _pagingController.refresh();
            },
            onSelectedPlantsChanged: (x) {
              _selectedPlants = x;
              _pagingController.refresh();
            },
            env: widget.env,
          ),
        ),
        PagedSliverList<int, EventCard>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<EventCard>(
            itemBuilder: (context, item, index) => item,
          ),
        )
      ],
    );
  }
}
