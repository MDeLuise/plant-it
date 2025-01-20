import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';

class PlantCard extends StatefulWidget {
  final Environment env;
  final Plant plant;

  const PlantCard(this.env, this.plant, {super.key});

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  String? base64Avatar;

  @override
  void initState() {
    super.initState();
    if (widget.plant.avatar != null) {
      widget.env.imageRepository
          .get(widget.plant.avatar!)
          .then((r) => setState(() => base64Avatar = r.base64));
    }
  }

  @override
  Widget build(BuildContext context) {
    final DecorationImage? backgroundImage = base64Avatar != null
        ? DecorationImage(
            image: MemoryImage(base64Decode(base64Avatar!)),
            fit: BoxFit.cover,
          )
        : null;

    // return Container(
    //   width: MediaQuery.of(context).size.width,
    //   margin: const EdgeInsets.symmetric(horizontal: 5.0),
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(15),
    //     image: backgroundImage,
    //     color: Colors.grey[200],
    //   ),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         widget.plant.name,
    //         //style: Theme.of(context).textTheme.headline6,
    //       ),
    //     ],
    //   ),
    // );
    return Stack(children: [
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
              style: TextStyle(color: Colors.white),
            ),
            // Text(
            //   widget.plant.species!,
            //   softWrap: false,
            //   overflow: TextOverflow.ellipsis,
            //   style: const TextStyle(color: Colors.grey),
            // ),
            Text("Monstera deliciosa"),
          ],
        ),
      ),
    ]);
  }
}
