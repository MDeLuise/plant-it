import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlantImageHeader extends StatefulWidget {
  final PlantDTO plant;
  final Environment env;

  const PlantImageHeader({super.key, required this.plant, required this.env});

  @override
  State<PlantImageHeader> createState() => _PlantImageHeaderState();
}

class _PlantImageHeaderState extends State<PlantImageHeader> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          "${widget.env.http.backendUrl}image/content/${widget.plant.avatarImageId}",
      httpHeaders: {
        "Key": widget.env.http.key!,
      },
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
      fit: BoxFit.cover,
      placeholder: (context, url) => Skeletonizer(
        enabled: true,
        effect: skeletonizerEffect,
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/images/no-image.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        return Container(
          color: const Color.fromRGBO(24, 44, 37, 1),
          child: Padding(
            padding: const EdgeInsets.all(100),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/no-image.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
