import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SpeciesImageHeader extends StatefulWidget {
  final SpeciesDTO species;
  final Environment env;

  const SpeciesImageHeader({
    super.key,
    required this.species,
    required this.env,
  });

  @override
  State<SpeciesImageHeader> createState() => _SpeciesImageHeaderState();
}

class _SpeciesImageHeaderState extends State<SpeciesImageHeader> {
  String? _url;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.species.id != null) {
      _url =
          "${widget.env.http.backendUrl}image/content/${widget.species.imageId}";
    } else if (widget.species.imageUrl != null) {
      _url = "${widget.env.http.backendUrl}proxy?url=${widget.species.imageUrl}";
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageToDisplay =
        const AssetImage("assets/images/no-image.png");
    if (_url != null) {
      imageToDisplay = CachedNetworkImageProvider(
        _url!,
        headers: {
          "Key": widget.env.http.key!,
        },
        imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
        errorListener: (p0) {
          imageToDisplay = const AssetImage("assets/images/no-image.png");
        },
      );
    }
    setState(() {
      _loading = false;
    });

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
