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
  late Plant _updatedPlant;

  @override
  void initState() {
    super.initState();
    _updatedPlant = widget.plant;

    widget.env.imageRepository
        .getSpecifiedAvatarForPlantBase64(_updatedPlant.id)
        .then((i) async {
      if (i != null) {
        setState(() => base64Avatar = i);
      }
    });
    widget.env.speciesRepository
        .get(_updatedPlant.species)
        .then((s) => setState(() => _speciesName = s.scientificName));
  }

  @override
  Widget build(BuildContext context) {
    final DecorationImage backgroundImage = base64Avatar != null
        ? DecorationImage(
            image: MemoryImage(base64Decode(base64Avatar!)),
            fit: BoxFit.cover,
          )
        : const DecorationImage(
            image: AssetImage("assets/images/generic-plant.jpg"),
            fit: BoxFit.cover,
          );

    return GestureDetector(
      onTap: () async {
        await navigateTo(context, PlantPage(widget.env, _updatedPlant))
            .then((a) {
          setState(() {});
        });
      },
      child: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: backgroundImage,
            color: Theme.of(context).colorScheme.primary.withOpacity(.7),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
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
                bottom: Radius.circular(5),
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
                _updatedPlant.name,
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
