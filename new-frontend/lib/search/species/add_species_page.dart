import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as flutter_image;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/loading_button.dart';
import 'package:plant_it/plant/add_plant_page.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:drift/drift.dart' as drift;

class AddSpeciesPage extends StatefulWidget {
  final Environment env;
  final String? name;

  const AddSpeciesPage(this.env, {super.key, this.name});

  @override
  State<AddSpeciesPage> createState() => _AddSpeciesPageState();
}

class _AddSpeciesPageState extends State<AddSpeciesPage> {
  final TextEditingController _scientificNameController =
      TextEditingController();
  final TextEditingController _genusController = TextEditingController();
  final TextEditingController _familyController = TextEditingController();
  final List<TextEditingController> _synonymControllers = [];
  SfRangeValues _phValues = const SfRangeValues(4, 6);
  SfRangeValues _temperatureValues = const SfRangeValues(-5, 20);
  double _lightValue = 5;
  double _humidityValue = 5;
  bool _usePhValue = false;
  bool _useTemperatureValue = false;
  bool _useLightValue = false;
  bool _useHumidityValue = false;

  @override
  void initState() {
    super.initState();
    if (widget.name != null) {
      _scientificNameController.text = widget.name!;
    }
  }

  void _addSynonymField() {
    setState(() {
      _synonymControllers.add(TextEditingController());
    });
  }

  void _removeSynonymField(int index) {
    setState(() {
      _synonymControllers[index].dispose();
      _synonymControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: flutter_image.Image.asset(
                "assets/images/generic-plant.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Collapsable(
                  "Classification",
                  [
                    _buildTextField("Family", _familyController),
                    _buildTextField("Genus", _genusController),
                    _buildTextField("Species", _scientificNameController),
                  ],
                  expandedAtStart: true,
                ),
                Collapsable(
                  "Synonyms",
                  _buildSynonymFields(),
                ),
                Collapsable(
                  "Care",
                  [
                    _RangeSlider(
                      label: "Temperature",
                      min: -50,
                      max: 50,
                      callback: (r) => setState(() => _temperatureValues = r),
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      interval: 20,
                      minorTicksPerInterval: 1,
                      stepSize: 5,
                      initial: const SfRangeValues(-5, 25),
                      enabled: _useTemperatureValue,
                      setEnabled: (e) =>
                          setState(() => _useTemperatureValue = e),
                    ),
                    if (_useTemperatureValue) const SizedBox(height: 20),
                    _Slider(
                      label: "Light",
                      min: 1,
                      max: 10,
                      callback: (r) => setState(() => _lightValue = r),
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      interval: 2,
                      minorTicksPerInterval: 1,
                      stepSize: 1,
                      initial: _lightValue,
                      enabled: _useLightValue,
                      setEnabled: (e) => setState(() => _useLightValue = e),
                    ),
                    if (_useLightValue) const SizedBox(height: 20),
                    _Slider(
                      label: "Humidity",
                      min: 0,
                      max: 100,
                      callback: (r) => setState(() => _humidityValue = r),
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      interval: 10,
                      minorTicksPerInterval: 0,
                      stepSize: 10,
                      initial: _humidityValue,
                      enabled: _useHumidityValue,
                      setEnabled: (e) => setState(() => _useHumidityValue = e),
                    ),
                    if (_useHumidityValue) const SizedBox(height: 20),
                    _RangeSlider(
                      label: "Ph",
                      min: 1,
                      max: 14,
                      callback: (r) => setState(() => _phValues = r),
                      showTicks: true,
                      showLabels: true,
                      enableTooltip: true,
                      interval: 2,
                      minorTicksPerInterval: 1,
                      stepSize: 1,
                      initial: const SfRangeValues(5, 9),
                      enabled: _usePhValue,
                      setEnabled: (e) => setState(() => _usePhValue = e),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LoadingButton(
                    'Add Species',
                    _addSpecies,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSynonymFields() {
    return [
      ..._synonymControllers.asMap().entries.map((entry) {
        int index = entry.key;
        TextEditingController controller = entry.value;
        return Row(
          children: [
            Expanded(child: _buildTextField("Synonym", controller)),
            IconButton(
              icon: const Icon(LucideIcons.trash),
              onPressed: () => _removeSynonymField(index),
            ),
          ],
        );
      }),
      TextButton(
        onPressed: _addSynonymField,
        child: Row(
          children: [
            Icon(LucideIcons.plus),
            const SizedBox(width: 5),
            Text("Add Synonym"),
          ],
        ),
      ),
    ];
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _addSpecies() async {
    final SpeciesCompanion speciesToSave = SpeciesCompanion(
      family: drift.Value.absentIfNull(
          _familyController.text.isEmpty ? null : _familyController.text),
      genus: drift.Value.absentIfNull(
          _genusController.text.isEmpty ? null : _genusController.text),
      scientificName: drift.Value(_scientificNameController.text),
      dataSource: const drift.Value(SpeciesDataSource.custom),
      species: drift.Value(_scientificNameController.text),
    );
    final SpeciesCareCompanion careToSave = SpeciesCareCompanion(
      light: _useLightValue
          ? drift.Value(_lightValue.toInt())
          : const drift.Value.absent(),
      humidity: _useHumidityValue
          ? drift.Value(_humidityValue.toInt())
          : const drift.Value.absent(),
      tempMin: _useTemperatureValue
          ? drift.Value(_temperatureValues.start.toInt())
          : const drift.Value.absent(),
      tempMax: _useTemperatureValue
          ? drift.Value(_temperatureValues.end.toInt())
          : const drift.Value.absent(),
      phMin: _useTemperatureValue
          ? drift.Value(_phValues.start.toInt())
          : const drift.Value.absent(),
      phMax: _useTemperatureValue
          ? drift.Value(_phValues.end.toInt())
          : const drift.Value.absent(),
    );
    try {
      final speciesId =
          await widget.env.speciesRepository.insert(speciesToSave);
      await widget.env.speciesCareRepository
          .insert(careToSave.copyWith(species: drift.Value(speciesId)));
      for (TextEditingController synonymController in _synonymControllers) {
        final SpeciesSynonymsCompanion synonym = SpeciesSynonymsCompanion(
          species: drift.Value(speciesId),
          synonym: drift.Value(synonymController.text),
        );
        await widget.env.speciesSynonymsRepository.insert(synonym);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding species')),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Species added successfully')),
    );
  }
}

class _RangeSlider extends StatefulWidget {
  final String label;
  final int min;
  final int max;
  final Function(SfRangeValues) callback;
  final bool showTicks;
  final bool showLabels;
  final bool enableTooltip;
  final double interval;
  final int minorTicksPerInterval;
  final double stepSize;
  final SfRangeValues initial;
  final bool enabled;
  final Function(bool) setEnabled;

  const _RangeSlider({
    required this.label,
    required this.min,
    required this.max,
    required this.callback,
    required this.showTicks,
    required this.showLabels,
    required this.enableTooltip,
    required this.interval,
    required this.minorTicksPerInterval,
    required this.stepSize,
    required this.initial,
    required this.enabled,
    required this.setEnabled,
  });

  @override
  State<_RangeSlider> createState() => _RangeSliderState();
}

class _RangeSliderState extends State<_RangeSlider> {
  late SfRangeValues _values;

  @override
  void initState() {
    super.initState();
    _values = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
                value: widget.enabled,
                onChanged: (a) {
                  if (a == null) {
                    return;
                  }
                  widget.setEnabled(a);
                }),
            Text(widget.label),
          ],
        ),
        if (widget.enabled)
          SfRangeSlider(
            min: widget.min,
            max: widget.max,
            values: _values,
            interval: widget.interval,
            showTicks: widget.showTicks,
            showLabels: widget.showLabels,
            enableTooltip: widget.enableTooltip,
            minorTicksPerInterval: widget.minorTicksPerInterval,
            onChanged: (rv) {
              setState(() => _values = rv);
              widget.callback(rv);
            },
            stepSize: widget.stepSize,
            shouldAlwaysShowTooltip: false,
          ),
      ],
    );
  }
}

class _Slider extends StatefulWidget {
  final String label;
  final int min;
  final int max;
  final Function(double) callback;
  final bool showTicks;
  final bool showLabels;
  final bool enableTooltip;
  final double interval;
  final int minorTicksPerInterval;
  final double stepSize;
  final double initial;
  final bool enabled;
  final Function(bool) setEnabled;

  const _Slider({
    required this.label,
    required this.min,
    required this.max,
    required this.callback,
    required this.showTicks,
    required this.showLabels,
    required this.enableTooltip,
    required this.interval,
    required this.minorTicksPerInterval,
    required this.stepSize,
    required this.initial,
    required this.enabled,
    required this.setEnabled,
  });

  @override
  State<_Slider> createState() => _SliderState();
}

class _SliderState extends State<_Slider> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
                value: widget.enabled,
                onChanged: (a) {
                  if (a == null) {
                    return;
                  }
                  widget.setEnabled(a);
                }),
            Text(widget.label),
          ],
        ),
        if (widget.enabled)
          SfSlider(
            min: widget.min,
            max: widget.max,
            value: _value,
            interval: widget.interval,
            showTicks: widget.showTicks,
            showLabels: widget.showLabels,
            enableTooltip: widget.enableTooltip,
            minorTicksPerInterval: widget.minorTicksPerInterval,
            onChanged: (v) {
              setState(() => _value = v);
              widget.callback(v);
            },
            stepSize: widget.stepSize,
            shouldAlwaysShowTooltip: false,
          ),
      ],
    );
  }
}
