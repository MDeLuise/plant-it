import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddOrEditPlantImageHeader extends StatefulWidget {
  final PlantDTO plant;
  final Environment env;

  const AddOrEditPlantImageHeader({super.key, required this.plant, required this.env});

  @override
  State<AddOrEditPlantImageHeader> createState() => _AddOrEditPlantImageHeaderState();
}

class _AddOrEditPlantImageHeaderState extends State<AddOrEditPlantImageHeader> {
  late String? _url;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _url = "image/content/${widget.plant.avatarImageId}";
    loadImage();
  }

  void loadImage() async {
    if (widget.plant.avatarImageId == null) {
      return;
    }
    final response = await widget.env.http.get(_url!);
    final blob = response.bodyBytes;
    setState(() {
      _url = 'data:image/jpg;base64,${base64Encode(blob)}';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageToDisplay =
        const AssetImage("assets/images/no-image.png");
    if (_url != null) {
      imageToDisplay = CachedNetworkImageProvider(_url!);
    }

    return Skeletonizer(
      enabled: _loading,
      effect: const PulseEffect(
        from: Colors.grey,
        to: Color.fromARGB(255, 207, 207, 207),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageToDisplay,
            //alignment: Alignment(
            //    widget.horizontalSlide, 0), // this does the parallax
            fit: BoxFit.cover,
          ),
        ),
        //alignment: Alignment(widget.horizontalSlide, 0),
      ),
    );
  }
}