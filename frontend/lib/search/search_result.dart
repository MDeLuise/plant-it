import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
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
  final List<SpeciesDTO> result;

  const SearchResultCard({
    super.key,
    required this.species,
    required this.env,
    required this.result,
  });

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    String? url;
    if (widget.species.id != null) {
      url =
          "${widget.env.http.backendUrl}image/content/${widget.species.imageId}";
    } else if (widget.species.imageUrl != null) {
      url = "${widget.env.http.backendUrl}proxy?url=${widget.species.imageUrl}";
    }

    ImageProvider<Object> imageToDisplay =
        const AssetImage("assets/images/no-image.png");
    if (url != null) {
      imageToDisplay = CachedNetworkImageProvider(
        url,
        headers: {
          "Key": widget.env.http.key!,
        },
        imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
        errorListener: (p0) {
          imageToDisplay = const AssetImage("assets/images/no-image.png");
        },
      );
    }
    _loading = false;

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
