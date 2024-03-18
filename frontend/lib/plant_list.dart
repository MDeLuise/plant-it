import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/plant_details.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PlantList extends StatefulWidget {
  final Environment env;
  const PlantList({super.key, required this.env});

  @override
  State<StatefulWidget> createState() => _PlantList();
}

class _PlantList extends State<PlantList> {
  final controller = PageController(viewportFraction: .8, keepPage: true);
  double page = 0.0;

  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        page = controller.page!;
      });
    });
    super.initState();
  }

  Widget _buildMobileView(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          SizedBox(
            height: screenSize.width *
                .7, // height: screenSize.width * .8 // screenSize.height * .55
            child: PageView.builder(
              itemCount: widget.env.plants?.length ?? 0,
              controller: controller,
              itemBuilder: (_, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => goToPageSlidingUp(
                    context,
                    PlantDetails(
                      env: widget.env,
                      plant: widget.env.plants![index],
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ParallaxPlantCard(
                          horizontalSlide:
                              (index - page).clamp(-1, 1).toDouble(),
                          plant: widget.env.plants![index],
                          http: widget.env.http)),
                );
              },
            ),
          ),
          SmoothPageIndicator(
            controller: controller,
            count: widget.env.plants?.length ?? 0,
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

  Widget _buildDesktopView(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: SizedBox(
        height: screenSize.height * .5,
        width: screenSize.width * .5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:
                      200, // Change this value as per your requirement
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: widget.env.plants?.length ?? 0,
                controller: controller,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => goToPageSlidingUp(
                      context,
                      PlantDetails(
                        env: widget.env,
                        plant: widget.env.plants![index],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ParallaxPlantCard(
                        horizontalSlide: (index - page).clamp(-1, 1).toDouble(),
                        plant: widget.env.plants![index],
                        http: widget.env.http,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSmallScreen(context)) {
      return _buildMobileView(context);
    } else {
      return _buildDesktopView(context);
    }
  }
}

class ParallaxPlantCard extends StatefulWidget {
  final PlantDTO plant;
  final double horizontalSlide;
  final AppHttpClient http;
  late final String _imageUrl;

  ParallaxPlantCard({
    super.key,
    required this.plant,
    required this.horizontalSlide,
    required this.http,
  }) {
    _imageUrl = "image/content/${plant.avatarImageId}";
  }

  @override
  State<ParallaxPlantCard> createState() => _ParallaxPlantCard();
}

class _ParallaxPlantCard extends State<ParallaxPlantCard> {
  String? _url;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadImageV1(widget._imageUrl, widget.http.key!);
  }

  void loadImageV1(String url, String key) async {
    final response = await widget.http.get(url);
    final blob = response.bodyBytes;
    setState(() {
      _url = 'data:image/jpg;base64,${base64Encode(blob)}';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> imageToDisplay =
        const AssetImage("assets/images/no-image.png");
    if (_url != null) {
      imageToDisplay = CachedNetworkImageProvider(_url!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Skeletonizer(
            enabled: _loading,
            effect: const PulseEffect(
              from: Colors.grey,
              to: Color.fromARGB(255, 207, 207, 207),
            ),
            child: AspectRatio(
              aspectRatio: 2 / 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: imageToDisplay,
                    //alignment: Alignment(
                    //    widget.horizontalSlide, 0), // this does the parallax
                    fit: BoxFit.cover,
                  ),
                ),
                //alignment: Alignment(widget.horizontalSlide, 0),
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.plant.info.personalName,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.plant.species!,
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
