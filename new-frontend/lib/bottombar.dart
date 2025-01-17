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
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          _currentIndex = index;
        });
        widget.callback(index);
      },
      indicatorColor: Theme.of(context).colorScheme.primary,
      selectedIndex: _currentIndex,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(LucideIcons.house),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(LucideIcons.calendar),
          label: 'Events',
        ),
        NavigationDestination(
          icon: Icon(LucideIcons.search),
          label: 'Search',
        ),
        NavigationDestination(
          icon: Icon(LucideIcons.ellipsis),
          label: 'More',
        )
      ],
    );
  }
}
