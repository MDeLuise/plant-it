import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/horizontal_list.dart';

class HomePage extends StatelessWidget {
  final Environment env;
  const HomePage({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return HorizontalList(
        cards: env.plants!
            .map((e) => PlantCard(
                  name: e.info.personalName,
                  species: e.species!,
                  env: env,
                  imageId: e.avatarImageId!,
                ))
            .toList());
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

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Expanded(
  //         child: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             image: _url != null
  //                 ? DecorationImage(
  //                     image: CachedNetworkImageProvider(_url!),
  //                     fit: BoxFit.cover,
  //                   )
  //                 : null,
  //           ),
  //           child: Align(
  //             alignment: Alignment.bottomLeft,
  //             child: Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Container(
  //                     width: double.infinity,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       color: Colors.black.withOpacity(0.3),
  //                     ),
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         Text(
  //                           widget.name,
  //                           softWrap: false,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: TextStyle(color: Colors.white),
  //                         ),
  //                         Text(
  //                           widget.species,
  //                           softWrap: false,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: const TextStyle(color: Colors.white),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.species,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ))
      ],
    );
  }
}
