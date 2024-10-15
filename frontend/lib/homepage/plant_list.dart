import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/plant_details/plant_details_page.dart';
import 'package:plant_it/theme.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PlantList extends StatefulWidget {
  final Environment env;
  const PlantList({
    super.key,
    required this.env,
  });

  @override
  State<StatefulWidget> createState() => _PlantListState();
}

class _PlantListState extends State<PlantList> {
  final controller = PageController(viewportFraction: .8, keepPage: true);
  double _page = 0.0;
  final TextEditingController _searchController = TextEditingController();
  List<PlantDTO> _filteredPlants = [];
  Timer? _debounce;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        _page = controller.page!;
      });
    });
    _filteredPlants = widget.env.plants;
    super.initState();
  }

  bool _matchName(String plantName, String matchingTerm) {
    return plantName.toLowerCase().contains(matchingTerm.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).searchInYourPlants,
                prefixIcon: const Icon(Icons.search_outlined),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                            _filteredPlants = widget.env.plants;
                          });
                        },
                        child: const Icon(Icons.close_outlined),
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  setState(() {
                    if (value.isEmpty) {
                      _filteredPlants = widget.env.plants;
                    } else {
                      _filteredPlants = _filteredPlants
                          .where((p) => _matchName(p.info.personalName!, value))
                          .toList();
                    }
                  });
                });
              },
            ),
          ),
          SizedBox(
            height: min(screenSize.width, maxWidth) *
                .7, // height: screenSize.width * .8 // screenSize.height * .55
            child: PageView.builder(
              itemCount: _filteredPlants.length,
              controller: controller,
              itemBuilder: (_, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    goToPageSlidingUp(
                      context,
                      PlantDetailsPage(
                        env: widget.env,
                        plant: _filteredPlants[index],
                      ),
                    ).then((reload) {
                      setState(() {
                        _filteredPlants = widget.env.plants;
                      });
                    });
                  },
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ParallaxPlantCard(
                        horizontalSlide:
                            (index - _page).clamp(-1, 1).toDouble(),
                        plant: _filteredPlants[index],
                        http: widget.env.http,
                        filteredPlants: _filteredPlants,
                      )),
                );
              },
            ),
          ),
          if (_filteredPlants.isNotEmpty)
            SmoothPageIndicator(
              controller: controller,
              count: _filteredPlants.length,
              effect: const ScrollingDotsEffect(
                dotWidth: 5.0,
                dotHeight: 5.0,
                activeDotScale: 2,
                activeDotColor: Color(
                  0xFF6DD075,
                ),
              ),
              onDotClicked: (index) => controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              ),
            )
        ],
      ),
    );
  }
}

class ParallaxPlantCard extends StatefulWidget {
  final PlantDTO plant;
  final double horizontalSlide;
  final AppHttpClient http;
  final List<PlantDTO> filteredPlants;

  const ParallaxPlantCard({
    super.key,
    required this.plant,
    required this.horizontalSlide,
    required this.http,
    required this.filteredPlants,
  });

  @override
  State<ParallaxPlantCard> createState() => _ParallaxPlantCard();
}

class _ParallaxPlantCard extends State<ParallaxPlantCard> {

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          "${widget.http.backendUrl}image/content/${widget.plant.avatarImageId}",
      httpHeaders: {
        "Key": widget.http.key!,
      },
      imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet,
      fit: BoxFit.cover,
      placeholder: (context, url) => Skeletonizer(
        enabled: true,
        effect: skeletonizerEffect,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 10,
            maxWidth: 10,
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
      errorWidget: (context, url, error) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(24, 44, 37, 1),
                borderRadius: BorderRadius.circular(10),
              ),
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
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.plant.info.personalName!,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors
                            .white), // Make text color white for better contrast
                  ),
                  Text(
                    widget.plant.species!,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      imageBuilder: (context, imageProvider) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Add a gradient overlay to the bottom
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
                  Text(
                    widget.plant.info.personalName!,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors
                            .white), // Make text color white for better contrast
                  ),
                  Text(
                    widget.plant.species!,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
