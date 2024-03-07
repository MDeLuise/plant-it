import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/events.dart';
import 'package:plant_it/homepage.dart';
import 'package:plant_it/more.dart';
import 'package:plant_it/search.dart';

class TempletePage extends StatefulWidget {
  final Environment env;

  const TempletePage({super.key, required this.env});

  @override
  State<TempletePage> createState() => _TempletePageState();
}

class _TempletePageState extends State<TempletePage> {
  late final Environment _env;
  final iconList = [
    Icons.home_outlined,
    Icons.calendar_month_outlined,
    Icons.search_outlined,
    Icons.menu,
  ];
  late final List<Widget> _pages;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _env = widget.env;
    _pages = [
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_currentIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape: const CircleBorder(),
          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            return Icon(
              iconList[index],
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
}
