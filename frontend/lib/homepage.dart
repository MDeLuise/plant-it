import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/commons.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:plant_it/environment.dart';

class HomePage extends StatelessWidget {
  final Environment env;
  const HomePage({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    //return const Center(child: Text("Home"));
    return SizedBox(
      height: height * (isSmallScreen(context) ? .7 : .5),
      child: Swiper(
        itemBuilder: (context, index) {
          return PlantCard(
            name: env.plants![index].info.personalName,
            species: env.plants![index].species!,
            imageId: env.plants![index].avatarImageId!,
            env: env,
          );
        },
        loop: false,
        itemCount: env.plants?.length ?? 0,
        //pagination: const SwiperPagination(),
        scale: isSmallScreen(context) ? .7 : .4,
        viewportFraction: isSmallScreen(context) ? .5 : .2,
        containerWidth: 200,
        containerHeight: 400,
        //control: const SwiperControl(),
      ),
    );
  }
}

class PlantCard extends StatefulWidget {
  final String name;
  final String species;
  final Environment env;
  final String imageId;
  late final String _imageUrl;

  PlantCard({
    super.key,
    required this.name,
    required this.species,
    required this.env,
    required this.imageId,
  }) {
    _imageUrl = "image/content/$imageId";
  }

  @override
  State<PlantCard> createState() => _PlantCard();
}

class _PlantCard extends State<PlantCard> {
  String? _url;

  @override
  void initState() {
    super.initState();
    loadImageV1(widget._imageUrl, widget.env.http.key!);
  }

  void loadImageV1(String url, String key) async {
    final response = await widget.env.http.get(url);
    final blob = response.bodyBytes;
    setState(() {
      _url = 'data:image/jpg;base64,${base64Encode(blob)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
              decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: _url != null
                ? DecorationImage(
                    image: CachedNetworkImageProvider(_url!),
                    fit: BoxFit.cover,
                  )
                : null,
          )),
        ),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                ),
                Text(
                  widget.species,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ))
      ],
    );
  }
}
