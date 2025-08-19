import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:plant_it/utils/icons.dart';

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
          _DynamicColorElement(context,
              isSelected: _indexSelected == -1,
              callback: () => _onColorSelected(-1, null)),
          ...defaults.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final color = entry.value;
              return _ColorElement(
                color,
                isSelected: _indexSelected == index,
                callback: () => _onColorSelected(index, color),
              );
            },
          ),
          _ColorPickerElement(
            context,
            isSelected: _indexSelected == defaults.length,
            callback: (c) => _onColorSelected(defaults.length, c),
          ),
        ],
      ),
    );
  }
}

class _ColorElement extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Function callback;

  const _ColorElement(this.color,
      {this.isSelected = false, required void Function() this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback(),
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                )
              : null,
        ),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 24,
        ),
      ),
    );
  }
}

class _DynamicColorElement extends StatefulWidget {
  final BuildContext context;
  final bool isSelected;
  final Function callback;

  const _DynamicColorElement(this.context,
      {this.isSelected = false, required void Function() this.callback});

  @override
  State<_DynamicColorElement> createState() => _DynamicColorElementState();
}

class _DynamicColorElementState extends State<_DynamicColorElement> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.callback(),
      child: Container(
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
      ),
    );
  }
}

class _ColorPickerElement extends StatefulWidget {
  final BuildContext context;
  final bool isSelected;
  final Function(Color c) callback;

  const _ColorPickerElement(this.context,
      {this.isSelected = false, required void Function(Color c) this.callback});

  @override
  State<_ColorPickerElement> createState() => _ColorPickerElementState();
}

class _ColorPickerElementState extends State<_ColorPickerElement> {
  Color pickerColor = const Color.fromARGB(255, 79, 170, 77);

  void _pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              enableAlpha: false,
              labelTypes: const [ColorLabelType.rgb],
              pickerColor: pickerColor,
              onColorChanged: (c) => pickerColor = c,
              pickerAreaBorderRadius:
                  const BorderRadius.all(Radius.circular(3)),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.callback(pickerColor);
                Navigator.of(context).pop();
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickColor,
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
            border: widget.isSelected
                ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                : const GradientBoxBorder(
                    gradient: LinearGradient(colors: [Colors.blue, Colors.red]),
                    width: 2,
                  ),
            borderRadius: BorderRadius.circular(50)),
        child: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          radius: 24,
          child: Icon(
            appIcons['pipette'],
            color: Theme.of(widget.context).colorScheme.surfaceDim,
          ),
        ),
      ),
    );
  }
}
