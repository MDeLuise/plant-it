import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/home/view_models/home_viewmodel.dart';

class Carousel extends StatefulWidget {
  final HomeViewModel viewModel;
  final String filter;

  const Carousel({
    super.key,
    required this.viewModel,
    required this.filter,
  });

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final CarouselController controller = CarouselController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<int> plantIds =
        widget.viewModel.plantMap.keys.toList().where((id) {
      return widget.viewModel.plantMap[id]!.name.toLowerCase().contains(widget.filter.toLowerCase());
    }).toList();
    final List<int> plantIdsList = plantIds.toList();

    return SizedBox(
      height: MediaQuery.of(context).size.height * .3,
      child: ListView(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 250), // MediaQuery.sizeOf(context).height / 2
            child: CarouselView.weighted(
              controller: controller,
              itemSnapping: true,
              flexWeights: const <int>[
                6,
                3,
                1
              ], // [1, 7, 1],  [7, 2, 2], [6, 4, 1]
              onTap: (index) =>
                  context.push(Routes.plantWithId(plantIdsList[index])),
              children: plantIds.map((int plantId) {
                return HeroLayoutCard(
                    plantId: plantId, viewModel: widget.viewModel);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class HeroLayoutCard extends StatelessWidget {
  final HomeViewModel viewModel;
  final int plantId;

  const HeroLayoutCard({
    super.key,
    required this.viewModel,
    required this.plantId,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: <Widget>[
        SizedBox(
          width: width * 7 / 8,
          height: 250,
          child: Image(
            fit: BoxFit.cover,
            image: viewModel.imagesBase64[plantId] == null
                ? const AssetImage("assets/images/generic-plant.jpg")
                : MemoryImage(base64Decode(viewModel.imagesBase64[plantId]!))
                    as ImageProvider,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                viewModel.plantMap[plantId]!.name,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white),
              ),
              // const SizedBox(height: 10),
              // Text(
              //   viewModel.plantMap[plantId]!.species.toString(),
              //   overflow: TextOverflow.clip,
              //   softWrap: false,
              //   style: Theme.of(context)
              //       .textTheme
              //       .bodyMedium
              //       ?.copyWith(color: Colors.white),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
