import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

class Bottombar extends StatefulWidget {
  final Function(int) callback;

  const Bottombar({super.key, required this.callback});

  @override
  State<StatefulWidget> createState() => _BottomBarState();
}

class _BottomBarState extends State<Bottombar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceBright,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildIcon(LucideIcons.house, 0, "Home"),
              _buildIcon(LucideIcons.calendar, 1, "Calendar"),
              _buildIcon(LucideIcons.search, 2, "Search"),
              _buildIcon(LucideIcons.menu, 3, "More"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index, String label) {
    return GestureDetector(
      onTap: () => setState(() {
        _currentIndex = index;
        widget.callback(index);
      }),
      child: Row(
        children: [
          Icon(
            icon,
            color: _currentIndex == index
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.onSurface,
            semanticLabel: label,
          ),
          if (index != 4) const SizedBox(width: 10),
        ],
      ),
    );
  }
}

// class Bottombar extends StatefulWidget {
//   final Function(int) callback;

//   const Bottombar({super.key, required this.callback});

//   @override
//   State<StatefulWidget> createState() => _BottomBarState();
// }

// class _BottomBarState extends State<Bottombar> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return NavigationBar(
//       indicatorColor: Theme.of(context).primaryColor,
//       onDestinationSelected: (int index) {
//         setState(() {
//           _currentIndex = index;
//         });
//         widget.callback(index);
//       },
//       selectedIndex: _currentIndex,
//       height: 65,
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       elevation: 10,
//       shadowColor: Theme.of(context).colorScheme.shadow,
//       destinations: <Widget>[
//         NavigationDestination(
//           icon: Icon(
//             LucideIcons.house,
//             color: Theme.of(context).colorScheme.onSurface,
//           ),
//           selectedIcon: Icon(
//             LucideIcons.house,
//             color: Theme.of(context).colorScheme.onPrimary,
//           ),
//           label: 'Home',
//         ),
//         NavigationDestination(
//           icon: Icon(
//             LucideIcons.calendar,
//             color: Theme.of(context).colorScheme.onSurface,
//           ),
//           selectedIcon: Icon(
//             LucideIcons.calendar,
//             color: Theme.of(context).colorScheme.onPrimary,
//           ),
//           label: 'Calendar',
//         ),
//         NavigationDestination(
//           icon: Icon(
//             LucideIcons.search,
//             color: Theme.of(context).colorScheme.onSurface,
//           ),
//           selectedIcon: Icon(
//             LucideIcons.search,
//             color: Theme.of(context).colorScheme.onPrimary,
//           ),
//           label: 'Search',
//         ),
//         NavigationDestination(
//           icon: Icon(
//             LucideIcons.circle_user,
//             color: Theme.of(context).colorScheme.onSurface,
//           ),
//           selectedIcon: Icon(
//             LucideIcons.circle_user,
//             color: Theme.of(context).colorScheme.onPrimary,
//           ),
//           label: 'More',
//         ),
//       ],
//     );
//   }
// }
