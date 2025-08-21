import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/calendar/widgets/calendar_screen.dart';
import 'package:plant_it/ui/home/view_models/home_viewmodel.dart';
import 'package:plant_it/ui/home/widgets/home_screen.dart';
import 'package:plant_it/ui/search/view_models/search_viewmodel.dart';
import 'package:plant_it/ui/search/widgets/search_page.dart';
import 'package:plant_it/ui/settings/view_models/settings_viewmodel.dart';
import 'package:plant_it/ui/settings/widgets/settings_screen.dart';
import 'package:plant_it/utils/stream_code.dart';

class AppMainView extends StatefulWidget {
  final HomeViewModel homeViewModel;
  final CalendarViewModel calendarViewModel;
  final SearchViewModel searchViewModel;
  final SettingsViewModel settingsViewModel;
  final StreamController<StreamCode> streamController;
  final int selectedView;

  const AppMainView({
    super.key,
    required this.homeViewModel,
    required this.calendarViewModel,
    required this.searchViewModel,
    required this.settingsViewModel,
    int? selectedView,
    required this.streamController,
  }) : selectedView = selectedView ?? 0;

  @override
  State<AppMainView> createState() => _AppMainViewState();
}

class _AppMainViewState extends State<AppMainView> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedView;
    _screens = [
      HomeScreen(
        viewModel: widget.homeViewModel,
        streamController: widget.streamController,
      ),
      CalendarScreen(
        viewModel: widget.calendarViewModel,
        streamController: widget.streamController,
      ),
      SearchPage(viewModel: widget.searchViewModel),
      SettingsScreen(viewModel: widget.settingsViewModel),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _selectedIndex == 3
          ? null
          : FloatingActionButton(
              onPressed: () => context.push(Routes.event),
              child: const Icon(Icons.add),
            ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}
