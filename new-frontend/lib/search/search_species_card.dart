import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/search/fetcher/species_fetcher.dart';
import 'package:plant_it/search/species/species_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/src/widgets/image.dart' as flutter_image;

class SearchSpeciesCard extends StatefulWidget {
  final Environment env;
  final SpeciesCompanion speciesPartial;
  final SpeciesFetcherFacade speciesFetcherFacade;

  const SearchSpeciesCard(
      this.env, this.speciesPartial, this.speciesFetcherFacade,
      {super.key});

  @override
  State<SearchSpeciesCard> createState() => _SearchSpeciesCardState();
}

class _SearchSpeciesCardState extends State<SearchSpeciesCard> {
  String? base64Avatar;

  @override
  void initState() {
    super.initState();
    widget.env.imageRepository
        .getSpecifiedAvatarForSpeciesBase64(widget.speciesPartial.id.value)
        .then((i) {
      if (i != null) {
        setState(() {
          base64Avatar = i;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String? avatarUrl = widget.speciesPartial.externalAvatarUrl.value;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () =>
            navigateTo(context, SpeciesPage(widget.env, widget.speciesPartial)),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .5,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor.withOpacity(.7),
              ),
              child: avatarUrl != null
                  ? CachedNetworkImage(
                      imageUrl: avatarUrl,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: const flutter_image.Image(
                            image:
                                AssetImage("assets/images/generic-plant.jpg"),
                            fit: BoxFit.cover),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: flutter_image.Image(
                          image: base64Avatar == null
                              ? AssetImage("assets/images/generic-plant.jpg")
                              : MemoryImage(base64Decode(base64Avatar!)),
                          fit: BoxFit.cover),
                    ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(.9),
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
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      child: Text(
                        widget.speciesPartial.dataSource.value.name,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  Text(
                    widget.speciesPartial.scientificName.value,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                  if (widget.speciesPartial.family.present &&
                      widget.speciesPartial.family.value != null)
                    Text(
                      widget.speciesPartial.family.value!,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
