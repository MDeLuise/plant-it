import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/search/species_details_page.dart';
import 'package:plant_it/search/tag.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SearchResultCard extends StatefulWidget {
  final SpeciesDTO species;
  final Environment env;
  late final String _imageUrl;
  final List<SpeciesDTO> result;

  SearchResultCard({
    super.key,
    required this.species,
    required this.env,
    required this.result,
  }) {
    if (species.id != null) {
      _imageUrl = "image/content/${species.imageId}";
    } else {
      _imageUrl = species.imageUrl!;
    }
  }

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  String? _url;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadImage(widget._imageUrl);
  }

  void loadImage(String url) async {
    final response = await widget.env.http.get(url);
    final blob = response.bodyBytes;
    setState(() {
      _url = 'data:image/jpg;base64,${base64Encode(blob)}';
      _loading = false;
    });
  }

  @override
  void didUpdateWidget(SearchResultCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.result != widget.result) {
      setState(() {
        _loading = true;
      });
      loadImage(widget._imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageToDisplay =
        const AssetImage("assets/images/no-image.png");
    if (_url != null) {
      imageToDisplay = CachedNetworkImageProvider(_url!);
    }

    Widget tag = Row(children: [
      const SizedBox(
        width: 6,
      ),
      TagChip(
        tag: AppLocalizations.of(context).custom.toUpperCase(),
      )
    ]);
    if (widget.species.creator != "USER") {
      tag = const SizedBox();
    }

    return GestureDetector(
      onTap: () => goToPageSlidingUp(
          context,
          SpeciesDetailsPage(
            species: widget.species,
            env: widget.env,
          )),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Skeletonizer(
                enabled: _loading,
                effect: skeletonizerEffect,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: imageToDisplay,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.species.scientificName,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                  tag,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
