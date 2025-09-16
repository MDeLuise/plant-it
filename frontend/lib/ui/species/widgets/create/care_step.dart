import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/species/view_models/add_species_viewmodel.dart';

class CareStep extends StepSection<AddSpeciesViewModel> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  final ValueNotifier<int?> _selectedLight = ValueNotifier(null);
  final ValueNotifier<int?> _ongoingLightSelection = ValueNotifier(null);
  final ValueNotifier<int?> _selectedHumidity = ValueNotifier(null);
  final ValueNotifier<int?> _ongoingHumiditySelection = ValueNotifier(null);
  final ValueNotifier<RangeValues?> _selectedPh = ValueNotifier(null);
  final ValueNotifier<RangeValues?> _ongoingPhSelection = ValueNotifier(null);
  final ValueNotifier<RangeValues?> _selectedTemp = ValueNotifier(null);
  final ValueNotifier<RangeValues?> _ongoingTemp = ValueNotifier(null);

  CareStep({
    super.key,
    required super.viewModel,
    required super.appLocalizations,
  });

  @override
  void cancel() {
    _ongoingHumiditySelection.value = _selectedHumidity.value;
    _ongoingPhSelection.value = _selectedPh.value;
    _ongoingLightSelection.value = _selectedLight.value;
    _ongoingTemp.value = _selectedTemp.value;
  }

  @override
  void confirm() {
    if (_ongoingLightSelection.value != null) {
      viewModel.setLight(_ongoingLightSelection.value!);
      _selectedLight.value = _ongoingLightSelection.value;
    }
    if (_ongoingHumiditySelection.value != null) {
      viewModel.setHumidity(_ongoingHumiditySelection.value!);
      _selectedHumidity.value = _ongoingHumiditySelection.value;
    }
    if (_ongoingTemp.value != null) {
      viewModel.setTempMin(_ongoingTemp.value!.start.toInt());
      viewModel.setTempMax(_ongoingTemp.value!.end.toInt());
      _selectedTemp.value = _ongoingTemp.value;
    }
    if (_ongoingPhSelection.value != null) {
      viewModel.setPhMin(_ongoingPhSelection.value!.start.toInt());
      viewModel.setPhMax(_ongoingPhSelection.value!.end.toInt());
      _selectedPh.value = _ongoingPhSelection.value;
    }
  }

  @override
  State<StatefulWidget> createState() => _CareStep();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  String get title => appLocalizations.care;

  @override
  String get value {
    String fields = "";
    if (_ongoingLightSelection.value != null) {
      fields += appLocalizations.light;
    }
    if (_ongoingHumiditySelection.value != null) {
      fields += "${fields.isEmpty ? "" : ", "}${appLocalizations.humidity}";
    }
    if (_ongoingTemp.value != null) {
      fields += "${fields.isEmpty ? "" : ", "}${appLocalizations.temperature}";
    }
    if (_ongoingPhSelection.value != null) {
      fields += "${fields.isEmpty ? "" : ", "}${appLocalizations.ph}";
    }
    if (fields.length > 30) {
      fields = "${fields.substring(0, 30)}...";
    }
    return fields;
  }
}

class _CareStep extends State<CareStep> {
  void _addLight(BuildContext context) async {
    double range = widget._ongoingLightSelection.value?.toDouble() ?? 5;
    final int? result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: SizedBox(
            height: 100,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Slider(
                value: range,
                min: 1,
                max: 10,
                divisions: 10,
                label: range.round().toString(),
                onChanged: (double values) {
                  setState(() {
                    range = values;
                  });
                },
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(L.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                widget._ongoingLightSelection.value = null;
                Navigator.of(context).pop();
              },
              child: Text(L.of(context).remove),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(range.toInt());
              },
              child: Text(L.of(context).save),
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget._ongoingLightSelection.value = result;
    }
  }

  void _addHumidity(BuildContext context) async {
    double range = widget._ongoingHumiditySelection.value?.toDouble() ?? 5;
    final int? result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: SizedBox(
            height: 100,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Slider(
                value: range,
                max: 10,
                min: 0,
                divisions: 10,
                label: range.round().toString(),
                onChanged: (double values) {
                  setState(() {
                    range = values;
                  });
                },
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(L.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                widget._ongoingHumiditySelection.value = null;
                Navigator.of(context).pop();
              },
              child: Text(L.of(context).remove),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(range.toInt());
              },
              child: Text(L.of(context).save),
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget._ongoingHumiditySelection.value = result;
    }
  }

  void _addTemperature(BuildContext context) async {
    RangeValues range = widget._ongoingTemp.value ?? RangeValues(-30, 50);
    final RangeValues? result = await showDialog<RangeValues>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: SizedBox(
            height: 100,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return RangeSlider(
                values: range,
                max: 50,
                min: -30,
                divisions: 16,
                labels: RangeLabels(
                  range.start.round().toString(),
                  range.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    range = values;
                  });
                },
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(L.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                widget._ongoingTemp.value = null;
                Navigator.of(context).pop();
              },
              child: Text(L.of(context).remove),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(range);
              },
              child: Text(L.of(context).save),
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget._ongoingTemp.value = result;
    }
  }

  void _addPh(BuildContext context) async {
    RangeValues range = widget._ongoingPhSelection.value ?? RangeValues(1, 14);
    final RangeValues? result = await showDialog<RangeValues>(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: SizedBox(
            height: 100,
            child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return RangeSlider(
                values: range,
                max: 14,
                min: 0,
                divisions: 14,
                labels: RangeLabels(
                  range.start.round().toString(),
                  range.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    range = values;
                  });
                },
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(L.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                widget._ongoingPhSelection.value = null;
                Navigator.of(context).pop();
              },
              child: Text(L.of(context).remove),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(range);
              },
              child: Text(L.of(context).save),
            ),
          ],
        );
      },
    );

    if (result != null) {
      widget._ongoingPhSelection.value = result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(L.of(context).care,
              style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 20),
          AnimatedBuilder(
            animation: widget._ongoingLightSelection,
            builder: (context, child) {
              return GestureDetector(
                onTap: () => _addLight(context),
                child: Card.outlined(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(L.of(context).light),
                        Row(
                          children: [
                            Text(widget._ongoingLightSelection.value
                                    ?.toString() ??
                                ""),
                            SizedBox(width: 10),
                            Icon(LucideIcons.chevron_right),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
              animation: widget._ongoingHumiditySelection,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () => _addHumidity(context),
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(L.of(context).humidity),
                          Row(
                            children: [
                              Text(widget._ongoingHumiditySelection.value
                                      ?.toString() ??
                                  ""),
                              SizedBox(width: 10),
                              Icon(LucideIcons.chevron_right),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          AnimatedBuilder(
              animation: widget._ongoingTemp,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () => _addTemperature(context),
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(L.of(context).temperature),
                          Row(
                            children: [
                              Text(widget._ongoingTemp.value == null
                                  ? ""
                                  : "${widget._ongoingTemp.value!.start}-${widget._ongoingTemp.value!.end}"),
                              SizedBox(width: 10),
                              Icon(LucideIcons.chevron_right),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          AnimatedBuilder(
              animation: widget._ongoingPhSelection,
              builder: (context, child) {
                return GestureDetector(
                  onTap: () => _addPh(context),
                  child: Card.outlined(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(L.of(context).ph),
                          Row(
                            children: [
                              Text(widget._ongoingPhSelection.value == null
                                  ? ""
                                  : "${widget._ongoingPhSelection.value!.start}-${widget._ongoingPhSelection.value!.end}"),
                              SizedBox(width: 10),
                              Icon(LucideIcons.chevron_right),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
