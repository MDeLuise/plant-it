import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditPlantImageHeader extends StatefulWidget {
  final PlantDTO plant;
  final Environment env;

  const EditPlantImageHeader({
    super.key,
    required this.plant,
    required this.env,
  });

  @override
  State<EditPlantImageHeader> createState() => _EditPlantImageHeaderState();
}

class _EditPlantImageHeaderState extends State<EditPlantImageHeader> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageToDisplay =
        const AssetImage("assets/images/no-image.png");
    imageToDisplay = CachedNetworkImageProvider(
      "${widget.env.http.backendUrl}image/content/${widget.plant.avatarImageId}",
      headers: {
        "Key": widget.env.http.key!,
      },
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
      errorListener: (p0) {
        imageToDisplay = const AssetImage("assets/images/no-image.png");
      },
    );
    setState(() {
      _loading = false;
    });

    return Skeletonizer(
      enabled: _loading,
      effect: skeletonizerEffect,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageToDisplay,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
