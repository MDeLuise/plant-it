import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/settings/view_models/edit_event_type_viewmodel.dart';
import 'package:plant_it/utils/common.dart' as common;

class ColorStep extends StepSection<EditEventTypeViewModel> {
  late final ValueNotifier<Color> _selectedColor =
      ValueNotifier(common.hexToColor(viewModel.color));
  late final ValueNotifier<Color> _ongoingSelection =
      ValueNotifier(common.hexToColor(viewModel.color));
  final ValueNotifier<bool> _valid = ValueNotifier(true);

  ColorStep({
    super.key,
    required super.viewModel,
  });

  @override
  void cancel() {
    _ongoingSelection.value = _selectedColor.value;
  }

  @override
  void confirm() {
    viewModel.setColor(colorToHex(_ongoingSelection.value));
    _selectedColor.value = _ongoingSelection.value;
  }

  @override
  State<StatefulWidget> createState() => _ColorStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _valid;

  @override
  String get title => "Color";

  @override
  String get value => _selectedColor.value.toHexString();
}

class _ColorStepState extends State<ColorStep> {
  final List<Color> _defaultColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.white,
    Colors.teal,
    Colors.yellow,
  ];
  final List<String> _defaultColorsNames = [
    "red",
    "green",
    "blue",
    "white",
    "teal",
    "yellow",
  ];
  late Color _customColor;
  late Color _ongoingSelection;

  @override
  void initState() {
    super.initState();
    int selectedColorIndex = _getSelectedDefaultColorIndex();
    if (selectedColorIndex == -1) {
      _customColor = widget._selectedColor.value;
      _ongoingSelection = widget._selectedColor.value;
    } else {
      _customColor = Colors.purple;
      _ongoingSelection = _defaultColors[selectedColorIndex];
    }
  }

  int _getSelectedDefaultColorIndex() {
    return _defaultColors.indexWhere(
        (c) => c.toHexString() == widget._selectedColor.value.toHexString());
  }

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
              pickerColor: _ongoingSelection,
              onColorChanged: (c) => _ongoingSelection = c,
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
                setState(() => _customColor = _ongoingSelection);
                widget._ongoingSelection.value = _ongoingSelection;
                widget._valid.value = true;
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Which color you want to use?",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
            animation: widget._ongoingSelection,
            builder: (context, _) {
              return Expanded(
                child: SingleChildScrollView(
                  child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 3.3 / 2,
                      children: [
                        ...List.generate(_defaultColors.length, (index) {
                          Color color = _defaultColors.elementAt(index);
                          bool isSelected =
                              widget._ongoingSelection.value.toHexString() ==
                                  color.toHexString();
                          return GestureDetector(
                            onTap: () {
                              widget._ongoingSelection.value = color;
                              widget._valid.value = true;
                            },
                            child: Card.outlined(
                                shape: isSelected
                                    ? RoundedRectangleBorder(
                                        borderRadius: BorderRadiusGeometry.all(
                                            Radius.circular(15)),
                                        side: isSelected
                                            ? BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 2)
                                            : BorderSide.none,
                                      )
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(backgroundColor: color),
                                      const SizedBox(height: 8),
                                      Text(_defaultColorsNames.elementAt(index),
                                          overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                )),
                          );
                        }),
                        GestureDetector(
                          onTap: _pickColor,
                          child: Card.outlined(
                              shape: widget._ongoingSelection.value ==
                                      _customColor
                                  ? RoundedRectangleBorder(
                                      borderRadius: BorderRadiusGeometry.all(
                                          Radius.circular(15)),
                                      side: widget._ongoingSelection.value ==
                                              _customColor
                                          ? BorderSide(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 2)
                                          : BorderSide.none,
                                    )
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: _customColor,
                                      child: Icon(
                                        LucideIcons.pipette,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text("custom",
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              )),
                        ),
                      ]),
                ),
              );
            }),
      ],
    );
  }
}
