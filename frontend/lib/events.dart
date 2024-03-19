import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/event_dto.dart';
import 'package:plant_it/edit_event.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/events_notifier.dart';
import 'package:provider/provider.dart';

import 'dropdown.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFieldMultipleDropDown(
                    onSelectedItemsChanged: widget.onSelectedPlantsChanged,
                    options: widget.env.plants == null
                        ? []
                        : widget.env.plants!
                            .map((e) => e.info.personalName)
                            .toList(),
                    text: AppLocalizations.of(context).plants,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFieldMultipleDropDown(
                    onSelectedItemsChanged: widget.onSelectedEventsChanged,
                    options: widget.env.eventTypes
                        ?.map((e) => getLocaleEvent(context, e))
                        .toList() as List<String>,
                    text: AppLocalizations.of(context).events,
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

class EventCard extends StatelessWidget {
  final Environment env;
  final String action;
  final String plant;
  final DateTime date;
  final EventDTO eventDTO;

  const EventCard({
    super.key,
    required this.env,
    required this.action,
    required this.plant,
    required this.date,
    required this.eventDTO,
  });

  String _formatTimePassed(BuildContext context, Duration timePassed) {
    if (timePassed.inDays == 0) {
      return AppLocalizations.of(context).today;
    } else if (timePassed.inDays == 1) {
      return AppLocalizations.of(context).yesterday;
    } else if (timePassed.inDays < 30) {
      if (timePassed.inDays > 0) {
        return AppLocalizations.of(context).nDaysAgo(timePassed.inDays);
      } else {
        return AppLocalizations.of(context)
            .nDaysInFuture(timePassed.inDays.abs());
      }
    } else if (timePassed.inDays < 365) {
      final months = (timePassed.inDays / 30).floor();
      return AppLocalizations.of(context).nMonthsAgo(months);
    } else {
      final years = (timePassed.inDays / 365).floor();
      return AppLocalizations.of(context).nYearsAgo(years);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[200]!; // Default color

    const Map<String, Color> typeColors = {
      'SEEDING': Color.fromRGBO(23, 122, 105, 1),
      'WATERING': Color.fromARGB(255, 55, 91, 159),
      'FERTILIZING': Color.fromARGB(255, 199, 26, 24),
      'BIOSTIMULATING': Color.fromARGB(255, 203, 106, 32),
      'MISTING': Color.fromRGBO(0, 62, 185, 0.4),
      'TRANSPLANTING': Color.fromARGB(255, 175, 118, 89),
      'WATER_CHANGING': Color.fromRGBO(40, 108, 169, 1),
      'OBSERVATION': Color.fromRGBO(105, 105, 105, 1),
      'TREATMENT': Color.fromRGBO(185, 23, 50, 1),
      'PROPAGATING': Color.fromRGBO(17, 96, 50, 1),
      'PRUNING': Color.fromARGB(102, 62, 6, 183),
      'REPOTTING': Color.fromRGBO(144, 85, 67, 1),
    };

    if (typeColors.containsKey(action)) {
      backgroundColor = typeColors[action]!;
    }

    final timePassed = DateTime.now().difference(date);
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final formattedTimePassed = _formatTimePassed(context, timePassed);

    IconData actionIcon = Icons.info; // Default icon
    final Map<String, IconData> typeIcons = {
      'SEEDING': Icons.grass_outlined,
      'WATERING': Icons.water_drop_outlined,
      'FERTILIZING': Icons.lunch_dining_outlined,
      'BIOSTIMULATING': Icons.battery_charging_full_outlined,
      'MISTING': Icons.shower_outlined,
      'TRANSPLANTING': Icons.add_home_outlined,
      'WATER_CHANGING': Icons.waves_outlined,
      'OBSERVATION': Icons.visibility_outlined,
      'TREATMENT': Icons.science_outlined,
      'PROPAGATING': Icons.child_friendly_outlined,
      'PRUNING': Icons.cut_outlined,
      'REPOTTING': Icons.cached_outlined,
    };

    if (typeIcons.containsKey(action)) {
      actionIcon = typeIcons[action]!;
    }

    return GestureDetector(
      onTap: () => goToPageSlidingUp(
          context, EditEventPage(env: env, eventDTO: eventDTO)),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Increased padding
        child: SizedBox(
          width: double.infinity, // Limit the width of the card
          child: Card(
            elevation: 6,
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Increased border radius
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Increased padding
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Add some space between icon and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$formattedDate ($formattedTimePassed)',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(
                                  255, 216, 216, 216)), // Larger text
                        ),
                        const SizedBox(
                            height: 3), // Add some space between text elements
                        Text(
                          plant,
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(
                                  255, 180, 180, 180)), // Larger text
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: .5,
                      child: Icon(
                        actionIcon,
                        size: 40,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ), // Icon representing the action
                ],
              ),
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
    }
  }

  Future<List<EventCard>> _getEventsPage(int pageNo) async {
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
      return entries.map((entry) => dtoToCard(entry, widget.env)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isSmallScreen(context)) {
      return _buildListView();
    } else {
      return _buildGridView();
    }
  }

  Widget _buildListView() {
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

  Widget _buildGridView() {
    return LayoutBuilder(
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
          PagedSliverGrid<int, EventCard>(
            pagingController: _pagingController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            builderDelegate: PagedChildBuilderDelegate<EventCard>(
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
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
