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
  final Function(SpeciesDTO) updateSpeciesLocally;

  const SearchResultCard({
    super.key,
    required this.species,
    required this.env,
    required this.result,
    required this.updateSpeciesLocally,
  });

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  String? _url;

  @override
  void initState() {
    super.initState();
    if (widget.species.id != null) {
      _url =
          "${widget.env.http.backendUrl}image/content/${widget.species.imageId}";
    } else if (widget.species.imageUrl != null) {
      _url =
          "${widget.env.http.backendUrl}proxy?url=${widget.species.imageUrl}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _url ?? "assets/images/no-image.png",
      httpHeaders: {
        "Key": widget.env.http.key!,
      },
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
      fit: BoxFit.cover,
      placeholder: (context, url) => AspectRatio(
        aspectRatio: 1,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * .4,
            minHeight: MediaQuery.of(context).size.height * .4,
          ),
          child: Skeletonizer(
            enabled: true,
            effect: skeletonizerEffect,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .4,
                minHeight: MediaQuery.of(context).size.height * .4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage("assets/images/no-image.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        return GestureDetector(
          onTap: () => goToPageSlidingUp(
            context,
            SpeciesDetailsPage(
              species: widget.species,
              env: widget.env,
              updateSpeciesLocally: widget.updateSpeciesLocally,
            ),
          ),
          child: Stack(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * .4,
                  minHeight: MediaQuery.of(context).size.height * .4,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(24, 44, 37, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(100),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage("assets/images/no-image.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
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
                    if (widget.species.creator == "USER")
                      TagChip(
                        tag: AppLocalizations.of(context).custom.toUpperCase(),
                      ),
                    Text(
                      widget.species.scientificName,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors
                              .white), // Make text color white for better contrast
                    ),
                    if (widget.species.family != null)
                      Text(
                        widget.species.family!,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      imageBuilder: (context, imageProvider) {
        return GestureDetector(
          onTap: () => goToPageSlidingUp(
            context,
            SpeciesDetailsPage(
              species: widget.species,
              env: widget.env,
              updateSpeciesLocally: widget.updateSpeciesLocally,
            ),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      _url == null ? const Color.fromRGBO(24, 44, 37, 1) : null,
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * .4,
                  minHeight: MediaQuery.of(context).size.height * .4,
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: EdgeInsets.all(_url == null ? 100 : 0),
                    child: Container(
                      padding: EdgeInsets.all(_url == null ? 100 : 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: _url == null ? BoxFit.contain : BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Add a gradient overlay to the bottom
              if (_url != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80, // Adjust the height as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(
                            10), // Match the container's borderRadius
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.9),
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
                    if (widget.species.creator == "USER")
                      TagChip(
                        tag: AppLocalizations.of(context).custom.toUpperCase(),
                      ),
                    Text(
                      widget.species.scientificName,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors
                              .white), // Make text color white for better contrast
                    ),
                    if (widget.species.family != null)
                      Text(
                        widget.species.family!,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
