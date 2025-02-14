import 'dart:async';

import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/homepage/plant_card.dart';
import 'package:plant_it/homepage/set_name.dart';
import 'package:plant_it/reminder/reminder_occurrence.dart';
import 'package:plant_it/reminder/reminder_occurrence_service.dart';
import 'package:plant_it/reminder/reminder_occurrence_card.dart';

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
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(widget.env),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Next Reminders",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const SizedBox(height: 5),
            _NextReminders(widget.env),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Collection",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          "You currently have ${_plants.length} plants",
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search plants",
                          prefixIcon: const Icon(LucideIcons.search),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    LucideIcons.x,
                                    color: Theme.of(context).hintColor,
                                  ),
                                  onPressed: _clearSearch,
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 10,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: FlutterCarousel(
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
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatefulWidget {
  final Environment env;

  const _Header(this.env);

  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  String _currentName = "User";

  @override
  void initState() {
    super.initState();
    widget.env.userSettingRepository.getOrDefault("username", "User").then((u) {
      setState(() => _currentName = u);
    });
  }

  void _showEditNameDialog() {
    showModalBottomSheet<void>(
      showDragHandle: false,
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (BuildContext context) {
        return SetNamePanel(widget.env, _setUsername, _currentName);
      },
    );
  }

  void _setUsername(String username) {
    final String toSave = username.isEmpty ? "User" : username;
    widget.env.userSettingRepository.put("username", toSave);
    setState(() => _currentName = username);
  }

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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                GestureDetector(
                  onTap: _showEditNameDialog,
                  child: Text(
                    _currentName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            //Icon(LucideIcons.bell),
          ],
        ),
      ),
    );
  }
}

class _NextReminders extends StatefulWidget {
  final Environment env;

  const _NextReminders(this.env);

  @override
  State<_NextReminders> createState() => _NextRemindersState();
}

class _NextRemindersState extends State<_NextReminders> {
  List<ReminderOccurrence> _nextOccurrences = [];

  @override
  void initState() {
    super.initState();
    ReminderOccurrenceService(widget.env)
        .getNextOccurrences(5)
        .then((r) => setState(() => _nextOccurrences = r));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: FlutterCarousel(
        options: FlutterCarouselOptions(
          height: 170,
          showIndicator: false,
          viewportFraction: .85,
        ),
        items: _nextOccurrences.map((o) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ReminderOccurrenceCard(
                  widget.env,
                  o,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
