import 'dart:async';

import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/events/event_card.dart';
import 'package:plant_it/homepage/plant_card.dart';
import 'package:plant_it/reminder/reminder_occurrence_card.dart';
import 'package:plant_it/reminder/reminder_occurrence.dart';
import 'package:plant_it/reminder/reminder_occurrence_service.dart';
import 'package:plant_it/tab_bar.dart';

class Homepage extends StatefulWidget {
  final Environment env;

  const Homepage(this.env, {super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Plant> _plants = [];
  List<Plant> _filteredPlants = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    widget.env.plantRepository.getAll().then((r) => setState(() {
          _plants = r;
          _filteredPlants = r;
        }));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        final query = _searchController.text.toLowerCase();
        _filteredPlants = _plants
            .where((plant) => plant.name.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _filteredPlants = _plants;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _Header(),
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search plants",
                  prefixIcon: const Icon(LucideIcons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(LucideIcons.x),
                          onPressed: _clearSearch,
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FlutterCarousel(
                options: FlutterCarouselOptions(
                  height: 400.0,
                  showIndicator: false,
                ),
                items: _filteredPlants.map((plant) {
                  return Builder(
                    builder: (BuildContext context) {
                      return PlantCard(
                        widget.env,
                        plant,
                        key: UniqueKey(),
                      );
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              _Recent(widget.env),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  String _getGreeting(int hour) {
    if (hour < 12) {
      return "Good morning";
    } else if (hour < 18) {
      return "Good afternoon";
    } else {
      return "Good evening";
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentHour = DateTime.now().hour;
    final greeting = _getGreeting(currentHour);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "User",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          //Icon(LucideIcons.bell),
        ],
      ),
    );
  }
}

class _Recent extends StatefulWidget {
  final Environment env;

  const _Recent(this.env);

  @override
  State<_Recent> createState() => _RecentState();
}

class _RecentState extends State<_Recent> {
  List<Event> _recentEvents = [];
  List<ReminderOccurrence> _nextReminderOccurrences = [];

  @override
  void initState() {
    super.initState();
    widget.env.eventRepository
        .getLast(5)
        .then((r) => setState(() => _recentEvents = r));
    ReminderOccurrenceService(widget.env)
        .getNextOccurrences(5)
        .then((r) => setState(() =>_nextReminderOccurrences = r));
  }

  @override
  Widget build(BuildContext context) {
    return AppTabBar(widget.env, [
      "Reminders",
      "Events"
    ], [
      Column(
        children: _nextReminderOccurrences
            .map((e) => ReminderOccurrenceCard(widget.env, e))
            .toList(),
      ),
      Column(
        children: _recentEvents.map((e) => EventCard(widget.env, e)).toList(),
      )
    ]);
  }
}
