import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/image.dart' as flutter_image;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/loading_button.dart';
import 'package:plant_it/plant/add_plant_page.dart';
import 'package:plant_it/search/species/species_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:drift/drift.dart' as drift;

enum _ImageMode { none, upload, url }

class EditSpeciesPage extends StatefulWidget {
  final Environment env;
  final SpeciesCompanion species;

  const EditSpeciesPage(this.env, this.species, {super.key});

  @override
  State<EditSpeciesPage> createState() => _EditSpeciesPageState();
}

class _EditSpeciesPageState extends State<EditSpeciesPage> {
  final TextEditingController _scientificNameController =
      TextEditingController();
  final TextEditingController _genusController = TextEditingController();
  final TextEditingController _familyController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<TextEditingController> _synonymControllers = [];
  SfRangeValues _phValues = const SfRangeValues(4, 6);
  SfRangeValues _temperatureValues = const SfRangeValues(-5, 20);
  double _lightValue = 5;
  double _humidityValue = 80;
  bool _usePhValue = false;
  bool _useTemperatureValue = false;
  bool _useLightValue = false;
  bool _useHumidityValue = false;
  bool _isDataLoaded = false;
  File? _image;
  _ImageMode _imageMode = _ImageMode.none;
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _scientificNameController.text = widget.species.scientificName.value;
    if (widget.species.genus.present) {
      _genusController.text = widget.species.genus.value ?? "";
    }
    if (widget.species.family.present) {
      _familyController.text = widget.species.family.value ?? "";
    }

    _loadSynonyms();
    _loadCareData();
    _loadImage();
  }

  Future<void> _loadSynonyms() async {
    final synonyms = await widget.env.speciesSynonymsRepository
        .getBySpecies(widget.species.id.value);

    setState(() {
      _synonymControllers = synonyms
          .map((synonym) => TextEditingController(text: synonym.synonym))
          .toList();
    });
  }

  Future<void> _loadCareData() async {
    final care =
        await widget.env.speciesCareRepository.get(widget.species.id.value);

    setState(() {
      if (care.light != null) {
        _lightValue = double.parse(care.light.toString());
        _useLightValue = true;
      }
      if (care.humidity != null) {
        _humidityValue = double.parse(care.humidity.toString());
        _useHumidityValue = true;
      }

      if (care.tempMin != null || care.tempMax != null) {
        _temperatureValues = SfRangeValues(care.tempMin, care.tempMax);
        _useTemperatureValue = true;
      }

      if (care.phMin != null || care.phMax != null) {
        _phValues = SfRangeValues(care.phMin, care.phMax);
        _usePhValue = true;
      }

      _isDataLoaded = true;
    });
  }

  Future<void> _loadImage() async {
    widget.env.imageRepository
        .getSpecifiedAvatarForSpecies(widget.species.id.value)
        .then((i) async {
      if (i != null && i.imageUrl != null) {
        setState(() {
          _imageMode = _ImageMode.url;
          _imageUrlController.text = i.imageUrl!;
        });
      } else if (i != null && i.imagePath != null) {
        setState(() {
          _imageMode = _ImageMode.upload;
          _image = File(i.imagePath!);
        });
      }
    });
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

  Future<Widget> _getSpeciesImage() async {
    final String? base64Avatar = await widget.env.imageRepository
        .getSpecifiedAvatarForSpeciesBase64(widget.species.id.value);

    if (widget.species.externalAvatarUrl.present) {
      return CachedNetworkImage(
        imageUrl: widget.species.externalAvatarUrl.value!,
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
          ),
        ),
        errorWidget: (context, url, error) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: const flutter_image.Image(
              image: AssetImage("assets/images/generic-plant.jpg"),
              fit: BoxFit.cover),
        ),
      );
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: flutter_image.Image(
            image: base64Avatar == null
                ? AssetImage("assets/images/generic-plant.jpg")
                : MemoryImage(base64Decode(base64Avatar)),
            fit: BoxFit.cover),
      );
    }
  }

  Future<void> _uploadNewPhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isDataLoaded
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 250.0,
                      floating: false,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      flexibleSpace: FutureBuilder<Widget>(
                        future: _getSpeciesImage(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: const flutter_image.Image(
                                  image: AssetImage(
                                      "assets/images/generic-plant.jpg"),
                                  fit: BoxFit.cover),
                            );
                          } else {
                            return snapshot.data ?? Container();
                          }
                        },
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
                              _buildTextField(
                                  "Species", _scientificNameController),
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
                                callback: (r) =>
                                    setState(() => _temperatureValues = r),
                                showTicks: true,
                                showLabels: true,
                                enableTooltip: true,
                                interval: 20,
                                minorTicksPerInterval: 1,
                                stepSize: 5,
                                initial: _temperatureValues,
                                enabled: _useTemperatureValue,
                                setEnabled: (e) =>
                                    setState(() => _useTemperatureValue = e),
                              ),
                              if (_useTemperatureValue)
                                const SizedBox(height: 20),
                              _Slider(
                                label: "Light",
                                min: 1,
                                max: 10,
                                callback: (r) =>
                                    setState(() => _lightValue = r),
                                showTicks: true,
                                showLabels: true,
                                enableTooltip: true,
                                interval: 2,
                                minorTicksPerInterval: 1,
                                stepSize: 1,
                                initial: _lightValue,
                                enabled: _useLightValue,
                                setEnabled: (e) =>
                                    setState(() => _useLightValue = e),
                              ),
                              if (_useLightValue) const SizedBox(height: 20),
                              _Slider(
                                label: "Humidity",
                                min: 0,
                                max: 100,
                                callback: (r) =>
                                    setState(() => _humidityValue = r),
                                showTicks: true,
                                showLabels: true,
                                enableTooltip: true,
                                interval: 10,
                                minorTicksPerInterval: 0,
                                stepSize: 10,
                                initial: _humidityValue,
                                enabled: _useHumidityValue,
                                setEnabled: (e) =>
                                    setState(() => _useHumidityValue = e),
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
                                initial: _phValues,
                                enabled: _usePhValue,
                                setEnabled: (e) =>
                                    setState(() => _usePhValue = e),
                              ),
                            ],
                          ),
                          Collapsable('Image', [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile<_ImageMode>(
                                  title: const Text("No Image"),
                                  value: _ImageMode.none,
                                  groupValue: _imageMode,
                                  onChanged: (value) {
                                    setState(() {
                                      _imageMode = value!;
                                      _image = null;
                                      _imageUrlController.clear();
                                    });
                                  },
                                ),
                                RadioListTile<_ImageMode>(
                                  title: const Text("Upload Custom Image"),
                                  value: _ImageMode.upload,
                                  groupValue: _imageMode,
                                  onChanged: (value) {
                                    setState(() {
                                      _imageMode = value!;
                                      _imageUrlController.clear();
                                    });
                                  },
                                ),
                                if (_imageMode == _ImageMode.upload)
                                  TextButton(
                                    onPressed: _uploadNewPhoto,
                                    style: const ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          Colors.transparent),
                                    ),
                                    child: Text(
                                      _image != null
                                          ? _image!.path
                                          : "Select Photo",
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                RadioListTile<_ImageMode>(
                                  title: const Text("Use Web Image"),
                                  value: _ImageMode.url,
                                  groupValue: _imageMode,
                                  onChanged: (value) {
                                    setState(() {
                                      _imageMode = value!;
                                      _image = null;
                                    });
                                  },
                                ),
                                if (_imageMode == _ImageMode.url)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: TextField(
                                      controller: _imageUrlController,
                                      decoration: const InputDecoration(
                                          labelText: "Image URL"),
                                    ),
                                  ),
                              ],
                            ),
                          ]),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: LoadingButton(
                              'Update Species',
                              _updateSpecies,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 45,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(context).colorScheme.surfaceBright,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                        ]),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
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
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          onPressed: _addSynonymField,
          child: Text(
            "Add Synonym",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            controller: controller,
          ),
        ],
      ),
    );
  }

  void _updateSpecies() async {
    final Specy speciesToSave = Specy(
      id: widget.species.id.value,
      family: _familyController.text.isEmpty ? null : _familyController.text,
      genus: _genusController.text.isEmpty ? null : _genusController.text,
      scientificName: _scientificNameController.text,
      dataSource: SpeciesDataSource.custom,
      species: _scientificNameController.text,
    );
    final SpeciesCareData careToSave = SpeciesCareData(
      species: widget.species.id.value,
      light: _useLightValue ? _lightValue.toInt() : null,
      humidity: _useHumidityValue ? _humidityValue.toInt() : null,
      tempMin: _useTemperatureValue ? _temperatureValues.start.toInt() : null,
      tempMax: _useTemperatureValue ? _temperatureValues.end.toInt() : null,
      phMin: _useTemperatureValue ? _phValues.start.toInt() : null,
      phMax: _useTemperatureValue ? _phValues.end.toInt() : null,
    );
    try {
      await widget.env.speciesRepository.update(speciesToSave);
      await widget.env.speciesCareRepository.update(careToSave);
      widget.env.speciesSynonymsRepository.delete(widget.species.id.value);
      for (TextEditingController synonymController in _synonymControllers) {
        final SpeciesSynonymsCompanion synonym = SpeciesSynonymsCompanion(
          species: drift.Value(widget.species.id.value),
          synonym: drift.Value(synonymController.text),
        );
        await widget.env.speciesSynonymsRepository.insert(synonym);
      }

      await widget.env.imageRepository
          .removeAvatarForSpecies(widget.species.id.value);
      if (_imageMode == _ImageMode.upload) {
        final String imagePath = await widget.env.imageRepository
            .saveImageFile(_image!, _image!.path.split('.').last);
        await widget.env.imageRepository.insert(ImagesCompanion(
          speciesId: widget.species.id,
          isAvatar: drift.Value(true),
          createdAt: drift.Value(DateTime.now()),
          imagePath: drift.Value(imagePath),
        ));
      } else if (_imageMode == _ImageMode.url) {
        await widget.env.imageRepository.insert(ImagesCompanion(
          speciesId: widget.species.id,
          isAvatar: drift.Value(true),
          createdAt: drift.Value(DateTime.now()),
          imageUrl: drift.Value(_imageUrlController.text),
        ));
      }
    } catch (e) {
      showSnackbar(
          context, FeedbackLevel.error, "Error updating species", null);
    }
    showSnackbar(
        context, FeedbackLevel.success, "Species updated successfully", null);
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => SpeciesPage(
        widget.env,
        speciesToSave.toCompanion(true),
      ),
    ));
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
            activeColor: Theme.of(context).primaryColor,
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
            activeColor: Theme.of(context).primaryColor,
          ),
      ],
    );
  }
}
