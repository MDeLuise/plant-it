import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/search/fetcher/species_fetcher.dart';
import 'package:plant_it/species_and_plant_widget_generator/species_care_widget_generator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/src/widgets/image.dart' as flutter_image;

class SpeciesPage extends StatefulWidget {
  final Environment env;
  final SpeciesCompanion species;
  final SpeciesFetcherFacade speciesFetcherFacade;

  const SpeciesPage(this.env, this.species, this.speciesFetcherFacade,
      {super.key});

  @override
  State<SpeciesPage> createState() => _SpeciesPageState();
}

class _SpeciesPageState extends State<SpeciesPage> {
  List<String> _speciesSynonyms = [];
  bool _synonymsLoading = true;
  bool _showAllSynonyms = false;
  bool _careLoading = true;
  List<SpeciesCareInfoWidget> _speciesCareInfoWidgets = [];
  Widget? _avatar;

  Future<void> _setImage() async {
    Widget imageWidget;

    if (widget.species.avatarUrl.value != null) {
      imageWidget = CachedNetworkImage(
        imageUrl: widget.species.avatarUrl.value!,
        fit: BoxFit.cover,
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        errorWidget: (context, url, error) => ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: const flutter_image.Image(
              image: AssetImage("assets/images/generic-plant.jpg"),
              fit: BoxFit.cover),
        ),
      );
    } else if (widget.species.avatar.value == null) {
      imageWidget = const flutter_image.Image(
          image: AssetImage("assets/images/generic-plant.jpg"),
          fit: BoxFit.cover);
    } else {
      imageWidget = await widget.env.imageRepository
          .get(widget.species.avatar.value!)
          .then((i) {
        return flutter_image.Image(
          image: MemoryImage(base64Decode(i.base64)),
          fit: BoxFit.cover,
        );
      });
    }
    setState(() {
      _avatar = imageWidget;
    });
  }

  void _setSpeciesCare() {
    widget.env.speciesCareRepository.get(widget.species.id.value).then((c) {
      final List<SpeciesCareInfoWidget> newSpeciesCareInfoWidgets =
          SpeciesCareWidgetGenerator(c).getWidgets();
      setState(() {
        _speciesCareInfoWidgets = newSpeciesCareInfoWidgets;
        _careLoading = false;
      });
    });
  }

  List<Widget> _buildSynonymsList() {
    int displayCount = _showAllSynonyms ? _speciesSynonyms.length : 5;
    return List.generate(min(_speciesSynonyms.length, displayCount), (index) {
      return Row(
        children: [
          const SizedBox(width: 4),
          const Icon(Icons.circle, size: 6),
          const SizedBox(width: 8),
          Text(_speciesSynonyms[index],
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    widget.speciesFetcherFacade.getSynonyms(widget.species).then((r) {
      setState(() {
        _speciesSynonyms = r;
        _synonymsLoading = false;
      });
    }).catchError((err) {
      // do nothing
    });
    _setImage();
    _setSpeciesCare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.6,
            elevation: 0,
            leading: IconButton(
              // just to add shadow
              icon: const Icon(
                Icons.arrow_back,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    blurRadius: 20,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _avatar ??
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                    ),
                  ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  LucideIcons.ellipsis_vertical,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      blurRadius: 20,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 8),
                      child: Text(
                        widget.species.dataSource.value.name,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Theme.of(context).colorScheme.surfaceDim,
                            ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(
                        widget.species.scientificName.value,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                      TextButton(
                          onPressed: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Add",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary),
                                  ),
                                  Icon(LucideIcons.plus,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Info
                  Text(
                    'Information',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium!,
                      children: [
                        TextSpan(
                            text:
                                "${widget.species.scientificName.value} is a species "),
                        const TextSpan(text: "of genus "),
                        TextSpan(
                          text: widget.species.genus.value,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const TextSpan(text: " and family "),
                        TextSpan(
                          text: widget.species.family.value,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const TextSpan(text: "."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Care
                  Text(
                    'Care',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 8),
                  _DynamicGridWidget(_speciesCareInfoWidgets, 4, _careLoading),
                  const SizedBox(height: 16),

                  if (_speciesSynonyms.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Synonyms',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('The species is also known as:'),
                            ..._buildSynonymsList(),
                            if (_speciesSynonyms.length > 5)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _showAllSynonyms = !_showAllSynonyms;
                                  });
                                },
                                child: Text(
                                  _showAllSynonyms ? 'Show Less' : 'Show More',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DynamicGridWidget extends StatefulWidget {
  final int maxNum;
  final List<Widget>? plantEventInfoWidgets;
  final bool isLoading;

  const _DynamicGridWidget(
      this.plantEventInfoWidgets, this.maxNum, this.isLoading);

  @override
  State<_DynamicGridWidget> createState() => _DynamicGridWidgetState();
}

class _DynamicGridWidgetState extends State<_DynamicGridWidget> {
  late int pages;

  @override
  void initState() {
    super.initState();
    pages = (widget.plantEventInfoWidgets!.length / widget.maxNum).ceil();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildSinglePage([
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 217, 217, 217),
          highlightColor: const Color.fromARGB(255, 192, 192, 192),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 217, 217, 217),
          highlightColor: const Color.fromARGB(255, 192, 192, 192),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
          ),
        ),
      ]);
    }
    if (pages == 1) {
      return _buildSinglePage(widget.plantEventInfoWidgets);
    }
    return _buildMultiplePages();
  }

  Widget _buildSinglePage(List<Widget>? tiles) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5, // 3
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: tiles?.length ?? 0,
      itemBuilder: (context, index) {
        return tiles!.elementAt(index);
      },
    );
  }

  Widget _buildMultiplePages() {
    final List<List<Widget>> pagesList =
        _chunkWidgets(widget.plantEventInfoWidgets!, widget.maxNum);

    final List<Widget> pageWidgets =
        pagesList.map((chunk) => _buildSinglePage(chunk)).toList();

    return FlutterCarousel(
      options: FlutterCarouselOptions(
        showIndicator: true,
        enableInfiniteScroll: false,
        viewportFraction: 1,
        indicatorMargin: 0,
        height: 230,
        slideIndicator: CircularSlideIndicator(
            slideIndicatorOptions: SlideIndicatorOptions(
          currentIndicatorColor: Theme.of(context).colorScheme.primary,
          indicatorBackgroundColor: Colors.grey.withOpacity(.5),
        )),
      ),
      items: pageWidgets,
    );
  }

  List<List<Widget>> _chunkWidgets(List<Widget> widgets, int chunkSize) {
    List<List<Widget>> chunks = [];
    for (var i = 0; i < widgets.length; i += chunkSize) {
      final chunk = widgets.sublist(
          i, i + chunkSize > widgets.length ? widgets.length : i + chunkSize);
      chunks.add(chunk);
    }
    return chunks;
  }
}
