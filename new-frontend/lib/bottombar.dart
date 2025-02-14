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
          color: Theme.of(context).colorScheme.surface,
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
              _buildIcon(LucideIcons.house, 0),
              _buildIcon(LucideIcons.calendar, 1),
              _buildIcon(LucideIcons.search, 2),
              _buildIcon(LucideIcons.circle_user, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
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
          ),
          if (index != 4) const SizedBox(width: 10),
        ],
      ),
    );
  }
}
