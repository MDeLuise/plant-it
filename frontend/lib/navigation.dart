import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/commons.dart';

class IconInfo {
  final Icon icon;
  final String title;

  IconInfo({required this.icon, required this.title});
}

// Widget getNavigation(BuildContext context, List<IconInfo> icons) {
//   final screenSize = MediaQuery.of(context).size;
//   final isSmallScreen = screenSize.width < screenSizeTreshold;
//   if (isSmallScreen) {
//     return _getMobileNavigation(icons);
//   } else {
//     return const SizedBox.shrink();
//   }
// }

// Widget _getMobileNavigation(List<IconInfo> icons) {
//   return AnimatedBottomNavigationBar.builder(
//     itemCount: icons.length,
//     tabBuilder: (int index, bool isActive) {
//       return Icon(
//         icons[index].icon.icon,
//         size: 24,
//         color: isActive ? Color.fromARGB(255, 46, 161, 5) : Colors.black,
//       );
//     },
//     activeIndex: _bottomNavIndex,
//     backgroundColor: Color.fromRGBO(117, 180, 168, 1),
//     gapLocation: GapLocation.center,
//     notchSmoothness: NotchSmoothness.softEdge,
//     leftCornerRadius: 20,
//     rightCornerRadius: 20,
//     splashColor: Color.fromRGBO(25, 57, 51, 1),
//     //splashSpeedInMilliseconds: 1000,
//     onTap: (index) => setState(() => _bottomNavIndex = index),
//   );
// }
