import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/plant/add_plant_page.dart';
import 'package:plant_it/search/species/edit_species_page.dart';
import 'package:plant_it/species_and_plant_widget_generator/species_care_widget_generator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/src/widgets/image.dart' as flutter_image;

class SpeciesPage extends StatefulWidget {
  final Environment env;
  final SpeciesCompanion species;

  const SpeciesPage(this.env, this.species, {super.key});

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
    final String? base64Avatar = await widget.env.imageRepository
        .getSpecifiedAvatarForSpeciesBase64(widget.species.id.value);

    if (widget.species.externalAvatarUrl.value != null) {
      imageWidget = CachedNetworkImage(
        imageUrl: widget.species.externalAvatarUrl.value!,
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
    } else if (base64Avatar == null) {
      imageWidget = const flutter_image.Image(
          image: AssetImage("assets/images/generic-plant.jpg"),
          fit: BoxFit.cover);
    } else {
      imageWidget = flutter_image.Image(
        image: MemoryImage(base64Decode(base64Avatar)),
        fit: BoxFit.cover,
      );
    }
    setState(() {
      _avatar = imageWidget;
    });
  }

  void _setSpeciesCare() {
    widget.env.speciesFetcherFacade.getCare(widget.species).then((c) {
      final SpeciesCareData data = SpeciesCareData(
        species: c.species.value,
        humidity: c.humidity.value,
        light: c.light.value,
        phMax: c.phMax.value,
        phMin: c.phMin.value,
        tempMax: c.tempMax.value,
        tempMin: c.tempMin.value,
      );
      final List<SpeciesCareInfoWidget> newSpeciesCareInfoWidgets =
          SpeciesCareWidgetGenerator(data).getWidgets();
      setState(() {
        _speciesCareInfoWidgets = newSpeciesCareInfoWidgets;
      });
    }).whenComplete(() {
      setState(() {
        _careLoading = false;
      });
    });
  }

  List<Widget> _buildSynonymsList(BuildContext context) {
    int displayCount = _showAllSynonyms ? _speciesSynonyms.length : 5;
    return List.generate(min(_speciesSynonyms.length, displayCount), (index) {
      return Row(
        children: [
          const SizedBox(width: 4),
          Icon(Icons.circle,
              size: 6, color: Theme.of(context).colorScheme.onSurface),
          const SizedBox(width: 8),
          Text(_speciesSynonyms[index],
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
    });
  }

  void _deleteSpecies() async {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      confirmBtnText: 'Delete',
      cancelBtnText: 'Cancel',
      title: "Delete species?",
      text:
          "Are you sure you want to delete the species? This will delete also all the linked plants",
      confirmBtnColor: Colors.red,
      textColor: Theme.of(context).colorScheme.onSurface,
      titleColor: Theme.of(context).colorScheme.onSurface,
      showCancelBtn: true,
      cancelBtnTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      barrierColor: Colors.grey.withAlpha(200),
      backgroundColor: Theme.of(context).colorScheme.surface,
      onConfirmBtnTap: () {
        try {
          widget.env.speciesRepository.delete(widget.species.id.value);
        } catch (e) {
          showSnackbar(
              context, FeedbackLevel.error, "Error deleting species", null);
          return;
        }
        showSnackbar(context, FeedbackLevel.success,
            "Species deleted successfully", null);
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      },
    );
  }

  void _duplicateSpecies() async {
    late final Specy duplicatedSpecies;
    try {
      final String duplicateName =
          "${widget.species.scientificName.value} (duplicate)";
      final int duplicatedId = await widget.env.speciesRepository.insert(
          widget.species.copyWith(
              scientificName: drift.Value(duplicateName),
              id: const drift.Value.absent(),
              species: drift.Value(duplicateName),
              dataSource: const drift.Value(SpeciesDataSource.custom)));
      duplicatedSpecies = await widget.env.speciesRepository.get(duplicatedId);

      await widget.env.speciesCareRepository.get(widget.species.id.value).then(
          (c) => widget.env.speciesCareRepository
              .insert(c.copyWith(species: duplicatedId).toCompanion(false)));
      for (SpeciesSynonym synonym in await widget.env.speciesSynonymsRepository
          .getBySpecies(widget.species.id.value)) {
        await widget.env.speciesSynonymsRepository
            .insert(synonym.toCompanion(false).copyWith(
                  species: drift.Value(duplicatedId),
                  id: const drift.Value.absent(),
                ));
      }
    } catch (e) {
      showSnackbar(
          context, FeedbackLevel.error, "Error duplicating species", null);
      return;
    }
    showSnackbar(context, FeedbackLevel.success, "Species duplicated", null);
    replaceTo(
      context,
      SpeciesPage(widget.env, duplicatedSpecies.toCompanion(false)),
    );
  }

  Future<void> _navigateToEditSpecies() async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSpeciesPage(widget.env, widget.species),
      ),
    );

    if (shouldRefresh == true) {
      // TODO
    }
  }

  @override
  void initState() {
    super.initState();
    widget.env.speciesFetcherFacade.getSynonyms(widget.species).then((r) {
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
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.6,
                elevation: 0,
                automaticallyImplyLeading: false,
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
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          child: Text(
                            widget.species.dataSource.value.name,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                      Text(
                        widget.species.scientificName.value,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextButton(
                          onPressed: () => navigateTo(context,
                              AddPlantPage(widget.env, widget.species)),
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.transparent),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "Add to collection",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Info
                      Text(
                        'Information',
                        style: Theme.of(context).textTheme.headlineSmall,
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
                                  color: Theme.of(context).primaryColor),
                            ),
                            const TextSpan(text: " and family "),
                            TextSpan(
                              text: widget.species.family.value,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            const TextSpan(text: "."),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Care
                      Text(
                        'Care',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      _DynamicGridWidget(
                          _speciesCareInfoWidgets, 4, _careLoading),
                      const SizedBox(height: 16),

                      if (_speciesSynonyms.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Synonyms',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('The species is also known as:'),
                                ..._buildSynonymsList(context),
                                if (_speciesSynonyms.length > 5)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _showAllSynonyms = !_showAllSynonyms;
                                      });
                                    },
                                    child: Text(
                                      _showAllSynonyms
                                          ? 'Show Less'
                                          : 'Show More',
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
          Positioned(
            top: 45,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).colorScheme.surfaceBright,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ]),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          Positioned(
            top: 45,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).colorScheme.surfaceBright,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ]),
              child: IconButton(
                onPressed: () {
                  showMenu(
                    context: context,
                    position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
                    color: Theme.of(context).colorScheme.surfaceBright,
                    items: [
                      PopupMenuItem(
                        value: 'edit',
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        enabled: widget.species.dataSource.value ==
                            SpeciesDataSource.custom,
                        child: ListTile(
                          leading: Icon(
                            LucideIcons.pencil,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          title: const Text('Edit'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'duplicate',
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        child: ListTile(
                          leading: Icon(
                            LucideIcons.copy,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          title: const Text('Duplicate'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'remove',
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        enabled: widget.species.dataSource.value ==
                            SpeciesDataSource.custom,
                        child: ListTile(
                          leading: Icon(
                            LucideIcons.trash,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          title: const Text('Remove'),
                        ),
                      ),
                    ],
                  ).then((value) {
                    if (value == 'edit') {
                      _navigateToEditSpecies();
                    } else if (value == 'duplicate') {
                      _duplicateSpecies();
                    } else if (value == 'remove') {
                      _deleteSpecies();
                    }
                  });
                },
                icon: Icon(
                  LucideIcons.ellipsis_vertical,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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
        childAspectRatio: 2.5,
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
          currentIndicatorColor: Theme.of(context).primaryColor,
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
