import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:plant_it/event/add_new_event.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/event/events_page.dart';
import 'package:plant_it/homepage/homepage.dart';
import 'package:plant_it/more/more_page.dart';
import 'package:plant_it/search/search_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TemplatePage extends StatefulWidget {
  final Environment env;

  const TemplatePage({
    super.key,
    required this.env,
  });

  @override
  State<TemplatePage> createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage> {
  late final Environment _env;
  final _bottombarIconList = [
    Icons.home_outlined,
    Icons.calendar_month_outlined,
    Icons.search_outlined,
    Icons.menu_outlined,
  ];
  late List<Widget> _bottombarPages;
  int _currentIndex = 0;
  final Color _iconActiveColor = const Color.fromARGB(255, 55, 189, 6);
  final Color _iconNotActiveColor = const Color.fromARGB(255, 156, 192, 172);

  @override
  void initState() {
    super.initState();
    _env = widget.env;
  }

  @override
  Widget build(BuildContext context) {
    _bottombarPages = [
      HomePage(env: _env),
      EventsPage(env: _env),
      SeachPage(env: _env),
      MorePage(env: _env),
    ];

    final screenSize = MediaQuery.of(context).size;
    final isWideScreen = screenSize.width > 600;

    return _buildTemplate(isWideScreen);
  }

  Widget _buildTemplate(bool isWideScreen) {
    return Scaffold(
      key: navigatorKey,
      extendBody: true,
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          bottom: false,
          child: isWideScreen
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _currentIndex,
                      onDestinationSelected: (index) {
                        setState(() => _currentIndex = index);
                      },
                      labelType: NavigationRailLabelType.all,
                      leading: FloatingActionButton(
                        onPressed: () =>
                            goToPageSlidingUp(context, AddNewEventPage(env: _env)),
                        child: const Icon(Icons.add),
                      ),
                      destinations: _bottombarIconList
                          .map((icon) => NavigationRailDestination(
                                icon: Icon(icon, color: _iconNotActiveColor),
                                selectedIcon: Icon(icon, color: _iconActiveColor),
                                label: const SizedBox.shrink(),
                              ))
                          .toList(),
                      backgroundColor: const Color.fromRGBO(24, 44, 37, 1),
                      selectedIconTheme: IconThemeData(color: _iconActiveColor),
                      unselectedIconTheme: IconThemeData(color: _iconNotActiveColor),
                    ),
                    Expanded(
                      child: _bottombarPages[_currentIndex],
                    ),
                  ],
                )
              : _bottombarPages[_currentIndex],
        ),
      ),
      floatingActionButton: isWideScreen
          ? null
          : FloatingActionButton(
              onPressed: () =>
                  goToPageSlidingUp(context, AddNewEventPage(env: _env)),
              child: const Icon(Icons.add),
            ),
      floatingActionButtonLocation: isWideScreen
          ? null
          : FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: isWideScreen
          ? null
          : AnimatedBottomNavigationBar.builder(
              itemCount: _bottombarIconList.length,
              tabBuilder: (int index, bool isActive) {
                return Icon(
                  _bottombarIconList[index],
                  size: 24,
                  color: isActive ? _iconActiveColor : _iconNotActiveColor,
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
            ),
    );
  }
}
