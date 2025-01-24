import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/species_and_plant_widget_generator/plant_event_widget_generator.dart';
import 'package:plant_it/species_and_plant_widget_generator/plant_reminder_widget_generator.dart';
import 'package:plant_it/species_and_plant_widget_generator/species_care_widget_generator.dart';

class PlantPage extends StatefulWidget {
  final Environment env;
  final Plant plant;

  const PlantPage(this.env, this.plant, {super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  DecorationImage? _avatar;
  List<SpeciesCareInfoWidget>? speciesCareInfoWidgets;
  List<PlantEventInfoWidget>? plantEventInfoWidgets;
  List<PlantReminderInfoWidget>? plantReminderInfoWidgets;
  Specy? _species;

  @override
  void initState() {
    super.initState();

    widget.env.speciesRepository.get(widget.plant.id).then((s) {
      setState(() {
        _species = s;
      });
    });

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

  void _setPlantCare() {
    widget.env.speciesCareRepository.get(widget.plant.species).then((c) {
      final List<SpeciesCareInfoWidget> newSpeciesCareInfoWidgets =
          SpeciesCareWidgetGenerator(c).getWidgets();
      setState(() {
        speciesCareInfoWidgets = newSpeciesCareInfoWidgets;
      });
    });

    PlantEventWidgetGenerator(widget.env, widget.plant).getWidgets().then((r) {
      setState(() {
        plantEventInfoWidgets = r;
      });
    });

    PlantReminderWidgetGenerator(widget.env, widget.plant)
        .getWidgets()
        .then((r) {
      setState(() {
        plantReminderInfoWidgets = r;
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
                    'Aspiditra Elatior Variegata',
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
                  Text(
                    "${widget.plant.name} is a plant of the species ${_species!.species}, genus ${_species!.genus} and family ${_species!.family}.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),

                  // Care
                  Text(
                    'Care',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  _DynamicGridWidget(speciesCareInfoWidgets, 4),
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
                  _DynamicGridWidget(plantReminderInfoWidgets, 6),
                  const SizedBox(height: 16),

                  // Events
                  Text(
                    'Events',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  _DynamicGridWidget(plantEventInfoWidgets, 6),
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

  const _DynamicGridWidget(this.plantEventInfoWidgets, this.maxNum);

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
        childAspectRatio: 3,
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

    // Use the pageWidgets in FlutterCarousel
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
