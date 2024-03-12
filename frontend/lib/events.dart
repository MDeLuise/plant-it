import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';

import 'multiple_dropdown.dart';

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
                const Text(
                  'Filter',
                  style: TextStyle(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFieldWithDropDown(
                    onSelectedItemsChanged: widget.onSelectedPlantsChanged,
                    options: widget.env.plants == null
                        ? []
                        : widget.env.plants!
                            .map((e) => e.info.personalName)
                            .toList(),
                    text: "Plant",
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFieldWithDropDown(
                    onSelectedItemsChanged: widget.onSelectedEventsChanged,
                    options: widget.env.eventTypes
                        ?.map((e) => formatEventType(e))
                        .toList() as List<String>,
                    text: "Event",
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class Event extends StatelessWidget {
  final String action;
  final String plant;
  final DateTime date;

  const Event({
    super.key,
    required this.action,
    required this.plant,
    required this.date,
  });

  String _formatTimePassed(Duration timePassed) {
    if (timePassed.inDays == 0) {
      return 'today';
    } else if (timePassed.inDays == 1) {
      return 'yesterday';
    } else if (timePassed.inDays < 30) {
      if (timePassed.inDays > 0) {
        return '${timePassed.inDays} days ago';
      } else {
        return '${timePassed.inDays.abs()} days in future (whaaat?)';
      }
    } else if (timePassed.inDays < 365) {
      final months = (timePassed.inDays / 30).floor();
      return '$months months ago';
    } else {
      final years = (timePassed.inDays / 365).floor();
      return '$years years ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[200]!; // Default color

    Map<String, Color> typeColors = {
      'SEEDING': const Color.fromRGBO(23, 122, 105, .4),
      'WATERING': const Color.fromRGBO(10, 86, 217, .4),
      'FERTILIZING': const Color.fromRGBO(240, 50, 46, .4),
      'BIOSTIMULATING': const Color.fromRGBO(232, 122, 37, .4),
      'MISTING': const Color.fromRGBO(0, 62, 185, 0.4),
      'TRANSPLANTING': const Color.fromRGBO(201, 135, 102, .4),
      'WATER_CHANGING': const Color.fromRGBO(40, 108, 169, .4),
      'OBSERVATION': const Color.fromRGBO(105, 105, 105, 0.4),
      'TREATMENT': const Color.fromRGBO(185, 23, 50, .4),
      'PROPAGATING': const Color.fromRGBO(17, 96, 50, .4),
      'PRUNING': const Color.fromARGB(102, 2, 64, 28),
      'REPOTTING': const Color.fromRGBO(144, 85, 67, .4),
    };

    if (typeColors.containsKey(action)) {
      backgroundColor = typeColors[action]!;
    }

    final timePassed = DateTime.now().difference(date);
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final formattedTimePassed = _formatTimePassed(timePassed);

    IconData actionIcon = Icons.info; // Default icon
    Map<String, IconData> typeIcons = {
      'SEEDING': Icons.grass_outlined,
      'WATERING': Icons.water_drop_outlined,
      'FERTILIZING': Icons.eco_outlined,
      'BIOSTIMULATING': Icons.eco_outlined,
      'MISTING': Icons.water_damage_outlined,
      'TRANSPLANTING': Icons.swap_vert_outlined,
      'WATER_CHANGING': Icons.waves_outlined,
      'OBSERVATION': Icons.visibility_outlined,
      'TREATMENT': Icons.healing_outlined,
      'PROPAGATING': Icons.crop_outlined,
      'PRUNING': Icons.cut_outlined,
      'REPOTTING': Icons.vpn_key_outlined,
    };

    if (typeIcons.containsKey(action)) {
      actionIcon = typeIcons[action]!;
    }

    return Padding(
      padding: const EdgeInsets.all(7.0), // Increased padding
      child: SizedBox(
        width: double.infinity, // Limit the width of the card
        child: Card(
          elevation: 6,
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Increased border radius
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0), // Increased padding
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Icon(
                    actionIcon,
                    size: 40,
                    color: const Color.fromARGB(255, 237, 237, 237),
                  ),
                ), // Icon representing the action
                const SizedBox(
                    width: 20), // Add some space between icon and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$formattedDate, $formattedTimePassed',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black), // Larger text
                      ),
                      const SizedBox(
                          height: 3), // Add some space between text elements
                      Text(
                        plant,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black), // Larger text
                      ),
                    ],
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.arrow_forward_ios,
                      color: Colors.black), // Right arrow icon
                ),
              ],
            ),
          ),
        ),
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
  final PagingController<int, Event> _pagingController =
      PagingController(firstPageKey: 0);
  List<String> _selectedPlants = [];
  List<String> _selectedEventTypes = [];

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
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
    }
  }

  Future<List<Event>> _getEventsPage(int pageNo) async {
    String url = "diary/entry?pageNo=$pageNo&pageSize=$_pageSize";
    if (_selectedEventTypes.isNotEmpty) {
      url +=
          "&eventTypes=${_selectedEventTypes.map((e) => encodeEventType(e)).join(',')}";
    }
    if (_selectedPlants.isNotEmpty && widget.env.plants != null) {
      final List<int> selectedPlantIds = widget.env.plants!
          .where((p) => _selectedPlants.contains(p.info.personalName))
          .map((p) => p.id!)
          .toList();
      url += "&plantIds=${selectedPlantIds.join(',')}";
    }
    final response = await widget.env.http.get(url);
    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final List<dynamic> entries = responseBody["content"];
      return entries.map((entry) {
        return Event(
          action: entry["type"],
          plant: entry["diaryTargetPersonalName"],
          date: DateTime.parse(entry["date"]),
        );
      }).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > screenSizeTreshold) {
      return _buildGridView();
    } else {
      return _buildListView();
    }
  }

  Widget _buildListView() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: FilterWidget(
            onSelectedEventsChanged: (x) {
              _selectedEventTypes = x;
              _pagingController.refresh();
            },
            onSelectedPlantsChanged: (x) {
              _selectedPlants = x;
              _pagingController.refresh();
            },
            env: widget.env,
          ),
        ),
        PagedSliverList<int, Event>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Event>(
            itemBuilder: (context, item, index) => item,
          ),
        )
      ],
    );
  }

  Widget _buildGridView() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          const itemWidth = 250; // Adjust the width of each grid item as needed
          final crossAxisCount = (constraints.maxWidth / itemWidth).floor();
          return CustomScrollView(slivers: <Widget>[
            SliverToBoxAdapter(
              child: FilterWidget(
                onSelectedEventsChanged: (x) {
                  _selectedEventTypes = x;
                  _pagingController.refresh();
                },
                onSelectedPlantsChanged: (x) {
                  _selectedPlants = x;
                  _pagingController.refresh();
                },
                env: widget.env,
              ),
            ),
            PagedSliverGrid<int, Event>(
              pagingController: _pagingController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              builderDelegate: PagedChildBuilderDelegate<Event>(
                itemBuilder: (context, item, index) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: item,
                  ),
                ),
              ),
            )
          ]);
        },
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
