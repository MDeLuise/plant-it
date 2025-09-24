import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/data/repository/notifications_lang_repository.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class AppMainView extends StatefulWidget {
  final HomeViewModel homeViewModel;
  final CalendarViewModel calendarViewModel;
  final SearchViewModel searchViewModel;
  final SettingsViewModel settingsViewModel;
  final StreamController<StreamCode> streamController;
  final int selectedView;
  final SharedPreferences pref;
  final NotificationsLangRepository notificationsLangRepository;

  const AppMainView({
    super.key,
    required this.homeViewModel,
    required this.calendarViewModel,
    required this.searchViewModel,
    required this.settingsViewModel,
    int? selectedView,
    required this.streamController,
    required this.pref,
    required this.notificationsLangRepository,
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

  Future<void> _insertTranslationsInDB() async {
    bool translationsAlreadyInserted =
        widget.pref.getBool('translationsInserted') ?? false;
    if (translationsAlreadyInserted) {
      return;
    }
    L appLocalizations = L.of(context);

    widget.notificationsLangRepository.put(true, appLocalizations.notificationTitle1);
    widget.notificationsLangRepository.put(true, appLocalizations.notificationTitle2);
    widget.notificationsLangRepository.put(true, appLocalizations.notificationTitle3);
    widget.notificationsLangRepository.put(true, appLocalizations.notificationTitle4);
    widget.notificationsLangRepository.put(true, appLocalizations.notificationTitle5);
    widget.notificationsLangRepository.put(true, appLocalizations.notificationTitle6);
    widget.notificationsLangRepository.put(true, appLocalizations.notificationTitle7);
    widget.notificationsLangRepository.put(true, appLocalizations.notificationTitle8);
    
    widget.notificationsLangRepository.put(false, appLocalizations.notificationBody1);
    widget.notificationsLangRepository.put(false, appLocalizations.notificationBody2);
    widget.notificationsLangRepository.put(false, appLocalizations.notificationBody3);
    widget.notificationsLangRepository.put(false, appLocalizations.notificationBody4);
    widget.notificationsLangRepository.put(false, appLocalizations.notificationBody5);
    widget.notificationsLangRepository.put(false, appLocalizations.notificationBody6);
    widget.notificationsLangRepository.put(false, appLocalizations.notificationBody7);
    widget.notificationsLangRepository.put(false, appLocalizations.notificationBody8);

    await widget.pref.setBool('translationsInserted', true);
  }

  @override
  Widget build(BuildContext context) {
    _insertTranslationsInDB();

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
        destinations: [
          NavigationDestination(
              icon: Icon(Icons.home), label: L.of(context).home),
          NavigationDestination(
              icon: Icon(Icons.calendar_month), label: L.of(context).calendar),
          NavigationDestination(
              icon: Icon(Icons.search), label: L.of(context).search),
          NavigationDestination(
              icon: Icon(Icons.more_horiz), label: L.of(context).more),
        ],
      ),
    );
  }
}
