import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/plant/plant_page.dart';

class PlantCard extends StatefulWidget {
  final Environment env;
  final Plant plant;

  const PlantCard(this.env, this.plant, {super.key});

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  String? base64Avatar;
  String _speciesName = "";

  @override
  void initState() {
    super.initState();
    if (widget.plant.avatar != null) {
      widget.env.imageRepository
          .get(widget.plant.avatar!)
          .then((r) => setState(() => base64Avatar = r.base64));
    }
    widget.env.speciesRepository
        .get(widget.plant.species)
        .then((s) => setState(() => _speciesName = s.scientificName));
  }

  @override
  Widget build(BuildContext context) {
    final DecorationImage? backgroundImage = base64Avatar != null
        ? DecorationImage(
            image: MemoryImage(base64Decode(base64Avatar!)),
            fit: BoxFit.cover,
          )
        : null;

    return GestureDetector(
      onTap: () => navigateTo(context, PlantPage(widget.env, widget.plant)),
      child: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: backgroundImage,
            color: Theme.of(context).colorScheme.primary.withOpacity(.7),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0),
                  Colors.black.withOpacity(.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.plant.name,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
              Text(_speciesName,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 177, 177, 177))),
            ],
          ),
        ),
      ]),
    );
  }
}
