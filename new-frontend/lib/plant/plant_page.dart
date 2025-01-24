import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/species_and_plant_widget_generator/plant_activity_widget_generator.dart';
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
  List<PlantActivityInfoWidget>? plantActivityInfoWidgets;
  bool _speciesCareLoad = true;

  @override
  void initState() {
    super.initState();
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
    setState(() {
      _speciesCareLoad = true;
    });

    widget.env.speciesCareRepository.get(widget.plant.species).then((c) {
      final List<SpeciesCareInfoWidget> newSpeciesCareInfoWidgets =
          SpeciesCareWidgetGenerator(c).getWidgets();
      setState(() {
        speciesCareInfoWidgets = newSpeciesCareInfoWidgets;
        _speciesCareLoad = false;
      });
    });

    PlantActivityWidgetGenerator(widget.env, widget.plant)
        .getWidgets()
        .then((r) {
      setState(() {
        plantActivityInfoWidgets = r;
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
                    "X is a plant of the species Z, genus Y and family X.",
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

                  GridView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: speciesCareInfoWidgets?.length ?? 0,
                    itemBuilder: (context, index) {
                      return speciesCareInfoWidgets!.elementAt(index);
                    },
                  ),
                  const SizedBox(height: 16),

                  // Activity
                  Text(
                    'Activity',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: plantActivityInfoWidgets?.length ?? 0,
                    itemBuilder: (context, index) {
                      return plantActivityInfoWidgets!.elementAt(index);
                    },
                  ),

                  // // Horizontal Scroll for Activity Cards
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: List.generate(activities.length, (index) {
                  //       var activity = activities[index];

                  //       // Only show the activities based on the current page index
                  //       if (index >= _pageIndex * 6 &&
                  //           index < (_pageIndex + 1) * 6) {
                  //         return Container(
                  //           margin: const EdgeInsets.only(right: 16),
                  //           decoration: BoxDecoration(
                  //             color: Colors.white.withOpacity(0.1),
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //           padding: const EdgeInsets.all(8),
                  //           width: MediaQuery.of(context).size.width *
                  //               0.4, // Adjust the width
                  //           child: Row(
                  //             children: [
                  //               const SizedBox(width: 10),
                  //               Icon(
                  //                 LucideIcons.hand_helping,
                  //                 color: Colors.white,
                  //                 size: 30,
                  //               ),
                  //               const SizedBox(width: 20),
                  //               Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     activity['event']!,
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .bodyLarge!
                  //                         .copyWith(color: Colors.white),
                  //                   ),
                  //                   const SizedBox(height: 4),
                  //                   Text(
                  //                     activity['time']!,
                  //                     style: Theme.of(context)
                  //                         .textTheme
                  //                         .bodyMedium!
                  //                         .copyWith(color: Colors.white70),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //       }

                  //       return Container();
                  //     }),
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
