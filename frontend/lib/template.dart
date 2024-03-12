import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/events.dart';
import 'package:plant_it/homepage.dart';
import 'package:plant_it/more.dart';
import 'package:plant_it/search.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';

class TempletePage extends StatefulWidget {
  final Environment env;

  const TempletePage({super.key, required this.env});

  @override
  State<TempletePage> createState() => _TempletePageState();
}

class _TempletePageState extends State<TempletePage> {
  late final Environment _env;
  final _bottombarIconList = [
    Icons.home_outlined,
    Icons.calendar_month_outlined,
    Icons.search_outlined,
    Icons.menu_outlined,
  ];
  late final List<Widget> _bottombarPages;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _env = widget.env;
    _bottombarPages = [
      HomePage(
        env: _env,
      ),
      EventsPage(
        env: _env,
      ),
      SeachPage(
        env: _env,
      ),
      MorePage(
        env: _env,
      ),
    ];
    _fetchEventTypes();
    _fetchPlants();
  }

  Future<void> _fetchEventTypes() async {
    try {
      final response = await _env.http.get("diary/entry/type");
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = json.decode(response.body);
        final List<String> eventTypes = List<String>.from(responseBody);
        _env.eventTypes = eventTypes;
      }
    } catch (e) {
      if (!context.mounted) return;
      showSnackbar(context, ContentType.failure, e.toString());
    }
  }

  Future<void> _fetchPlants() async {
    try {
      final response = await _env.http.get("plant");
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final List<dynamic> plantJsonList = responseBody["content"];
        _env.plants =
            plantJsonList.map((json) => PlantDTO.fromJson(json)).toList();
      }
    } catch (e) {
      if (!context.mounted) return;
      showSnackbar(context, ContentType.failure, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < screenSizeTreshold;
    if (isSmallScreen) {
      return _mobileTemplate();
    } else {
      return _desktopTemplate();
    }
  }

  Widget _mobileTemplate() {
    return Scaffold(
        key: _env.scaffoldMessengerKey,
        extendBody: true,
        body: _bottombarPages[_currentIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape: const CircleBorder(),
          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: _bottombarIconList.length,
          tabBuilder: (int index, bool isActive) {
            return Icon(
              _bottombarIconList[index],
              size: 24,
              color: isActive
                  ? const Color.fromARGB(255, 55, 189, 6)
                  : const Color.fromARGB(255, 156, 192, 172),
            );
          },
          activeIndex: _currentIndex,
          backgroundColor: const Color.fromRGBO(24, 44, 37, 1),
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          leftCornerRadius: 20,
          rightCornerRadius: 20,
          splashColor: const Color.fromRGBO(24, 44, 37, 1),
          onTap: (index) => setState(() => _currentIndex = index),
        ));
  }

  Widget _desktopTemplate() {
    return Scaffold(
      key: _env.scaffoldMessengerKey,
      body: Row(
        children: [
          SideMenu(
            backgroundColor: const Color.fromRGBO(24, 44, 37, 1),
            hasResizer: false,
            builder: (data) {
              return SideMenuData(
                //header: const Text('Header'),
                items: [
                  // can not be in a separate _sideMenuPages = [...]. I think because _currentIndex == x is evaluated at declaration time?
                  SideMenuItemDataTile(
                      isSelected: _currentIndex == 0,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      hasSelectedLine: false,
                      highlightSelectedColor: Colors.transparent,
                      onTap: () => setState(() => _currentIndex = 0),
                      title: 'Home',
                      titleStyle: const TextStyle(
                          color: Color.fromARGB(255, 156, 192, 172)),
                      selectedTitleStyle: const TextStyle(
                        color: Color.fromARGB(255, 55, 189, 6),
                      ),
                      icon: const Icon(Icons.home_outlined),
                      selectedIcon: const Icon(Icons.home),
                      tooltip: "Home"),
                  SideMenuItemDataTile(
                    isSelected: _currentIndex == 1,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    hasSelectedLine: false,
                    highlightSelectedColor: Colors.transparent,
                    onTap: () => setState(() => _currentIndex = 1),
                    title: 'Events',
                    tooltip: "Events",
                    titleStyle: const TextStyle(
                        color: Color.fromARGB(255, 156, 192, 172)),
                    selectedTitleStyle: const TextStyle(
                      color: Color.fromARGB(255, 55, 189, 6),
                    ),
                    icon: const Icon(Icons.calendar_month_outlined),
                    selectedIcon: const Icon(Icons.calendar_month),
                  ),
                  SideMenuItemDataTile(
                    isSelected: _currentIndex == 2,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    hasSelectedLine: false,
                    highlightSelectedColor: Colors.transparent,
                    onTap: () => setState(() => _currentIndex = 2),
                    title: 'Search',
                    tooltip: "Search",
                    titleStyle: const TextStyle(
                        color: Color.fromARGB(255, 156, 192, 172)),
                    selectedTitleStyle: const TextStyle(
                      color: Color.fromARGB(255, 55, 189, 6),
                    ),
                    icon: const Icon(Icons.search_outlined),
                    selectedIcon: const Icon(Icons.search),
                  ),
                ],
                //footer: const Text('Footer'),
              );
            },
          ),
          Expanded(
            child: Center(
              child: _bottombarPages[_currentIndex],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
