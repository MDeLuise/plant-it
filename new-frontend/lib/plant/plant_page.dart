import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/species_and_plant_widget_generator/plant_event_widget_generator.dart';
import 'package:plant_it/species_and_plant_widget_generator/plant_reminder_widget_generator.dart';
import 'package:plant_it/species_and_plant_widget_generator/species_care_widget_generator.dart';
import 'package:shimmer/shimmer.dart';

class PlantPage extends StatefulWidget {
  final Environment env;
  final Plant plant;

  const PlantPage(this.env, this.plant, {super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  DecorationImage? _avatar;
  List<SpeciesCareInfoWidget> speciesCareInfoWidgets = [];
  List<PlantEventInfoWidget> plantEventInfoWidgets = [];
  List<PlantReminderInfoWidget> plantReminderInfoWidgets = [];
  Specy? _species;
  bool _isSpeciesCareLoading = true;
  bool _isPlantEventLoading = true;
  bool _isPlantReminderLoading = true;
  bool _isSpeciesLoading = true;

  @override
  void initState() {
    super.initState();
    _setSpecies();
    _setPlantCare();
    widget.env.imageRepository.get(widget.plant.avatar!).then((i) {
      final DecorationImage newAvatar = DecorationImage(
        image: MemoryImage(base64Decode(i.base64)),
        fit: BoxFit.cover,
      );
      setState(() {
        _avatar = newAvatar;
      });
    });
  }

  void _setSpecies() {
    if (!mounted) return;
    widget.env.speciesRepository.get(widget.plant.id).then((s) {
      setState(() {
        _species = s;
        _isSpeciesLoading = false;
      });
    });
  }

  void _setPlantCare() {
    widget.env.speciesCareRepository.get(widget.plant.species).then((c) {
      final List<SpeciesCareInfoWidget> newSpeciesCareInfoWidgets =
          SpeciesCareWidgetGenerator(c).getWidgets();
      setState(() {
        speciesCareInfoWidgets = newSpeciesCareInfoWidgets;
        _isSpeciesCareLoading = false;
      });
    });

    PlantEventWidgetGenerator(widget.env, widget.plant).getWidgets().then((r) {
      setState(() {
        plantEventInfoWidgets = r;
        _isPlantEventLoading = false;
      });
    });

    PlantReminderWidgetGenerator(widget.env, widget.plant)
        .getWidgets()
        .then((r) {
      setState(() {
        plantReminderInfoWidgets = r;
        _isPlantReminderLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: _avatar,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(LucideIcons.ellipsis_vertical),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.plant.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    _species?.scientificName ?? '',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white70, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 16),

                  // Info
                  Text(
                    'Information',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white70),
                      children: [
                        TextSpan(
                            text:
                                "${widget.plant.name} is a plant of the species "),
                        TextSpan(
                          text: _species!.species,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const TextSpan(text: ", genus "),
                        TextSpan(
                          text: _species!.genus,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const TextSpan(text: " and family "),
                        TextSpan(
                          text: _species!.family,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const TextSpan(text: "."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Care
                  Text(
                    'Care',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  _DynamicGridWidget(
                      speciesCareInfoWidgets, 4, _isSpeciesCareLoading),
                  const SizedBox(height: 16),

                  // Reminder
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        'Reminders',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text("Edit"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _DynamicGridWidget(
                      plantReminderInfoWidgets, 6, _isPlantReminderLoading),
                  const SizedBox(height: 16),

                  // Events
                  Text(
                    'Events',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  _DynamicGridWidget(
                      plantEventInfoWidgets, 6, _isPlantEventLoading),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DynamicGridWidget extends StatefulWidget {
  final int maxNum;
  final List<Widget>? plantEventInfoWidgets;
  final bool isLoading;

  const _DynamicGridWidget(
      this.plantEventInfoWidgets, this.maxNum, this.isLoading);

  @override
  State<_DynamicGridWidget> createState() => _DynamicGridWidgetState();
}

class _DynamicGridWidgetState extends State<_DynamicGridWidget> {
  late int pages;

  @override
  void initState() {
    super.initState();
    pages = (widget.plantEventInfoWidgets!.length / widget.maxNum).ceil();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildSinglePage([
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 217, 217, 217),
          highlightColor: const Color.fromARGB(255, 192, 192, 192),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 217, 217, 217),
          highlightColor: const Color.fromARGB(255, 192, 192, 192),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
          ),
        ),
      ]);
    }
    if (pages == 1) {
      return _buildSinglePage(widget.plantEventInfoWidgets);
    }
    return _buildMultiplePages();
  }

  Widget _buildSinglePage(List<Widget>? tiles) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5, // 3
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: tiles?.length ?? 0,
      itemBuilder: (context, index) {
        return tiles!.elementAt(index);
      },
    );
  }

  Widget _buildMultiplePages() {
    final List<List<Widget>> pagesList =
        _chunkWidgets(widget.plantEventInfoWidgets!, widget.maxNum);

    final List<Widget> pageWidgets =
        pagesList.map((chunk) => _buildSinglePage(chunk)).toList();

    return FlutterCarousel(
      options: FlutterCarouselOptions(
        showIndicator: true,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        indicatorMargin: 0,
        height: 230,
      ),
      items: pageWidgets,
    );
  }

  List<List<Widget>> _chunkWidgets(List<Widget> widgets, int chunkSize) {
    List<List<Widget>> chunks = [];
    for (var i = 0; i < widgets.length; i += chunkSize) {
      final chunk = widgets.sublist(
          i, i + chunkSize > widgets.length ? widgets.length : i + chunkSize);
      chunks.add(chunk);
    }
    return chunks;
  }
}
