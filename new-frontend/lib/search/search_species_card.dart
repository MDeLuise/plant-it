import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:plant_it/database/database.dart';

class SearchSpeciesCard extends StatefulWidget {
  final SpeciesCompanion speciesCompanion;

  const SearchSpeciesCard(this.speciesCompanion, {super.key});

  @override
  State<SearchSpeciesCard> createState() => _SearchSpeciesCardState();
}

class _SearchSpeciesCardState extends State<SearchSpeciesCard> {
  @override
  Widget build(BuildContext context) {
    final String? avatarUrl = widget.speciesCompanion.avatarUrl.value;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * .5,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.primary.withOpacity(.7),
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
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  : null),
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
                Text(
                  widget.speciesCompanion.scientificName.value,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  widget.speciesCompanion.family.value,
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
  }
}
