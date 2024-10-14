import 'package:flutter/material.dart';

class FloatingTabBar extends StatefulWidget {
  final List<String> titles;
  final List<VoidCallback> callbacks;

  const FloatingTabBar({
    super.key,
    required this.titles,
    required this.callbacks,
  });

  @override
  State<FloatingTabBar> createState() => _FloatingTabBarState();
}

class _FloatingTabBarState extends State<FloatingTabBar> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(widget.titles.length, (index) {
        final bool isActive = _activeIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _activeIndex = index;
            });
            widget.callbacks[index]();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
            decoration: BoxDecoration(
              color: isActive
                  ? Color.fromARGB(255, 240, 227, 227)
                  : Color.fromARGB(255, 18, 48, 42),
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Color.fromARGB(255, 18, 48, 42)),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 12, 33, 29),
                  blurRadius: 10.0,
                  offset: Offset(0, 5),
                )
              ],
            ),
            child: Text(
              widget.titles[index],
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }
}
