import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:plant_it/event/add_new_event.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/event/events.dart';
import 'package:plant_it/homepage/homepage.dart';
import 'package:plant_it/more/more_page.dart';
import 'package:plant_it/search/search_page.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
    if (isSmallScreen(context)) {
      return _mobileTemplate();
    } else {
      return _desktopTemplate();
    }
  }

  Widget _mobileTemplate() {
    return Scaffold(
        key: navigatorKey,
        extendBody: true,
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            bottom: false,
            child: _bottombarPages[_currentIndex],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              goToPageSlidingUp(context, AddNewEventPage(env: _env)),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
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
        ));
  }

  Widget _desktopTemplate() {
    return Scaffold(
      key: navigatorKey,
      body: TalkerWrapper(
        talker: widget.env.logger,
        child: Row(
          children: [
            SideMenu(
              backgroundColor: const Color.fromRGBO(24, 44, 37, 1),
              hasResizer: false,
              builder: (data) {
                return SideMenuData(
                  items: [
                    // can not be in a separate _sideMenuPages = [...]. I think because _currentIndex == x is evaluated at declaration time?
                    SideMenuItemDataTile(
                        isSelected: _currentIndex == 0,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        hasSelectedLine: false,
                        highlightSelectedColor: Colors.transparent,
                        onTap: () => setState(() => _currentIndex = 0),
                        title: 'Home',
                        titleStyle: TextStyle(color: _iconNotActiveColor),
                        selectedTitleStyle: TextStyle(
                          color: _iconActiveColor,
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
                      titleStyle: TextStyle(color: _iconNotActiveColor),
                      selectedTitleStyle: TextStyle(
                        color: _iconActiveColor,
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
                      titleStyle: TextStyle(color: _iconNotActiveColor),
                      selectedTitleStyle: TextStyle(
                        color: _iconActiveColor,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
