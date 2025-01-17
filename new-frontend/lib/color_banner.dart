import 'package:flutter/material.dart';
import 'package:plant_it/icons.dart';

class ColorBanner extends StatefulWidget {
  final BuildContext context;
  final Function(Color? color) callback;

  const ColorBanner(this.context, this.callback, {super.key});

  @override
  State<ColorBanner> createState() => _ColorBannerState();
}

class _ColorBannerState extends State<ColorBanner> {
  final List<Color> defaults = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.white,
    Colors.teal,
    Colors.yellow,
  ];
  int _indexSelected = -1;

  @override
  void initState() {
    super.initState();
  }

  void _onColorSelected(int index, Color? color) {
    setState(() {
      _indexSelected = index;
    });
    widget.callback(color);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _onColorSelected(-1, null),
            child: _DynamicColorElement(
              context,
              isSelected: _indexSelected == -1,
            ),
          ),
          ...defaults.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final color = entry.value;
              return GestureDetector(
                onTap: () => _onColorSelected(index, color),
                child: _ColorElement(
                  color,
                  isSelected: _indexSelected == index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ColorElement extends StatelessWidget {
  final Color color;
  final bool isSelected;

  const _ColorElement(this.color, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              )
            : null,
      ),
      child: CircleAvatar(
        backgroundColor: color,
        radius: 24,
      ),
    );
  }
}

class _DynamicColorElement extends StatefulWidget {
  final BuildContext context;
  final bool isSelected;

  const _DynamicColorElement(this.context, {this.isSelected = false});

  @override
  State<_DynamicColorElement> createState() => _DynamicColorElementState();
}

class _DynamicColorElementState extends State<_DynamicColorElement> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: widget.isSelected
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : null,
      ),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        radius: 24,
        child: Icon(
          appIcons['palette'],
          color: Theme.of(widget.context).colorScheme.surfaceDim,
        ),
      ),
    );
  }
}
