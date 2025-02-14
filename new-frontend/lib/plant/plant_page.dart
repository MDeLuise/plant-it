import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/more/reminder/reminder_list_page.dart';
import 'package:plant_it/plant/edit_plant_page.dart';
import 'package:plant_it/plant_gallery/plant_gallery.dart';
import 'package:plant_it/search/species/species_page.dart';
import 'package:plant_it/species_and_plant_widget_generator/plant_event_widget_generator.dart';
import 'package:plant_it/species_and_plant_widget_generator/plant_reminder_widget_generator.dart';
import 'package:plant_it/species_and_plant_widget_generator/species_care_widget_generator.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:drift/drift.dart' as drift;
import 'package:plant_it/database/database.dart' as db_image;

class PlantPage extends StatefulWidget {
  final Environment env;
  final Plant plant;

  const PlantPage(this.env, this.plant, {super.key});

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  final ImagePicker _picker = ImagePicker();
  DecorationImage? _avatar;
  List<SpeciesCareInfoWidget> speciesCareInfoWidgets = [];
  List<PlantEventInfoWidget> plantEventInfoWidgets = [];
  List<PlantReminderInfoWidget> plantReminderInfoWidgets = [];
  Specy? _species;
  bool _isSpeciesCareLoading = true;
  bool _isPlantEventLoading = true;
  bool _isPlantReminderLoading = true;
  bool _isSpeciesLoading = true;
  List<db_image.Image> plantImages = [
    // 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    // 'iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFUlEQVR42mP8z8BQz0AEYBxVSF+FABJADveWkH6oAAAAAElFTkSuQmCC',
    // 'iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFUlEQVR42mNk+M9Qz0AEYBxVSF+FAAhKDveksOjmAAAAAElFTkSuQmCC',
    // 'iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFUlEQVR42mNkYPhfz0AEYBxVSF+FAP5FDvcfRYWgAAAAAElFTkSuQmCC',
    // 'R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==',
    // 'iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFUlEQVR42mP8z8BQz0AEYBxVSF+FABJADveWkH6oAAAAAElFTkSuQmCC',
  ];
  bool _isPlantImagesLoading = true;

  @override
  void initState() {
    super.initState();
    _setSpecies();
    _setPlantCare();

    // Load avatar image
    widget.env.imageRepository
        .getSpecifiedAvatarForPlant(widget.plant.id)
        .then((avatarImage) async {
      if (avatarImage != null) {
        try {
          final base64 =
              await widget.env.imageRepository.getBase64(avatarImage.id);
          setState(() {
            _avatar = DecorationImage(
              image: MemoryImage(base64Decode(base64)),
              fit: BoxFit.cover,
            );
          });
        } catch (_) {
          _setDefaultAvatar();
        }
      } else {
        _setDefaultAvatar();
      }
    });

    // Load gallery images
    widget.env.imageRepository
        .getImagesForPlant(widget.plant.id)
        .then((images) async {
      setState(() {
        plantImages = images;
        _isPlantImagesLoading = false;
      });
    });
  }

  void _setDefaultAvatar() {
    setState(() {
      _avatar = const DecorationImage(
        image: AssetImage("assets/images/generic-plant.jpg"),
        fit: BoxFit.cover,
      );
    });
  }

  void _setSpecies() {
    widget.env.speciesRepository.get(widget.plant.species).then((s) {
      setState(() {
        _species = s;
        _isSpeciesLoading = false;
      });
    });
  }

  void _setPlantCare() {
    widget.env.speciesCareRepository.get(widget.plant.species).then((c) {
      final List<SpeciesCareInfoWidget> newSpeciesCareInfoWidgets =
          SpeciesCareWidgetGenerator(c).getWidgets();
      setState(() {
        speciesCareInfoWidgets = newSpeciesCareInfoWidgets;
        _isSpeciesCareLoading = false;
      });
    });

    PlantEventWidgetGenerator(widget.env, widget.plant).getWidgets().then((r) {
      setState(() {
        plantEventInfoWidgets = r;
        _isPlantEventLoading = false;
      });
    });

    PlantReminderWidgetGenerator(widget.env, widget.plant)
        .getWidgets()
        .then((r) {
      setState(() {
        plantReminderInfoWidgets = r;
        _isPlantReminderLoading = false;
      });
    });
  }

  void _deletePlant() async {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      confirmBtnText: 'Delete',
      cancelBtnText: 'Cancel',
      title: "Delete plant?",
      text:
          "Are you sure you want to delete the plant and all the linked data?",
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
          widget.env.plantRepository.delete(widget.plant.id);
        } catch (e) {
          showSnackbar(
              context, FeedbackLevel.error, "Error deleting plant", null);
          return;
        }
        showSnackbar(
            context, FeedbackLevel.success, "Plant deleted successfully", null);
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      },
    );
  }

  void _duplicatePlant() async {
    late final Plant duplicatedPlant;
    try {
      final String duplicateName = "${widget.plant.name} (duplicate)";
      final int duplicatedId = await widget.env.plantRepository
          .insert(widget.plant.toCompanion(false).copyWith(
                name: drift.Value(duplicateName),
                id: const drift.Value.absent(),
              ));
      duplicatedPlant = await widget.env.plantRepository.get(duplicatedId);
    } catch (e) {
      showSnackbar(
          context, FeedbackLevel.error, "Error duplicating plant", null);
      return;
    }
    showSnackbar(context, FeedbackLevel.success, "Plant duplicated", null);
    replaceTo(context, PlantPage(widget.env, duplicatedPlant));
  }

  Future<void> _uploadNewPhoto() async {
    setState(() {
      _isPlantImagesLoading = true;
    });
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final File file = File(pickedFile.path);
    final String extension = pickedFile.name.split('.').last;

    try {
      // Step 1: Save the file locally
      final String savedPath =
          await widget.env.imageRepository.saveImageFile(file, extension);

      // Step 2: Insert image into DB
      final ImagesCompanion newImage = ImagesCompanion(
        imagePath: drift.Value(savedPath),
        plantId: drift.Value(widget.plant.id),
        createdAt: drift.Value(DateTime.now()),
      );

      final int newImageId = await widget.env.imageRepository.insert(newImage);

      final db_image.Image saved =
          await widget.env.imageRepository.get(newImageId);

      // Step 5: Refresh UI
      setState(() {
        plantImages.insert(0, saved);
      });

      showSnackbar(context, FeedbackLevel.success, "Photo uploaded", null);
    } catch (e) {
      showSnackbar(
          context, FeedbackLevel.error, "Failed to upload image", e.toString());
    } finally {
      setState(() {
        _isPlantImagesLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * .6,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      image: _avatar,
                      color: Theme.of(context).primaryColor.withAlpha(200),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: Colors.transparent,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.plant.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      GestureDetector(
                        onTap: () => navigateTo(
                            context,
                            SpeciesPage(
                                widget.env, _species!.toCompanion(true))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _species?.scientificName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(width: 5),
                            Icon(LucideIcons.external_link,
                                size: 10,
                                color: Theme.of(context).primaryColor),
                          ],
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
                                    "${widget.plant.name} is a plant of the species "),
                            TextSpan(
                              text: _species?.species,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            const TextSpan(text: ", genus "),
                            TextSpan(
                              text: _species?.genus,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            const TextSpan(text: " and family "),
                            TextSpan(
                              text: _species?.family,
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
                          speciesCareInfoWidgets, 4, _isSpeciesCareLoading),
                      const SizedBox(height: 16),

                      // Reminder
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            'Reminders',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          GestureDetector(
                            onTap: () => navigateTo(context,
                                ReminderListPage(widget.env, widget.plant)),
                            child: const Text("Edit"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _DynamicGridWidget(
                          plantReminderInfoWidgets, 6, _isPlantReminderLoading),
                      const SizedBox(height: 16),

                      // Events
                      Text(
                        'Events',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      _DynamicGridWidget(
                          plantEventInfoWidgets, 6, _isPlantEventLoading),
                      const SizedBox(height: 16),

                      // Gallery
                      Text(
                        'Gallery',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      if (!_isPlantImagesLoading)
                        PlantGallery(
                          maxThumbnails: 5,
                          images: plantImages,
                          imageRepository: widget.env.imageRepository,
                          allowUpload: true,
                          onUpload: _uploadNewPhoto,
                        ),
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
                            color: Theme.of(context).colorScheme.onSurface),
                        child: ListTile(
                          leading: Icon(
                            LucideIcons.pencil,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          title: Text('Edit'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'duplicate',
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        child: ListTile(
                          leading: Icon(
                            LucideIcons.copy,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          title: Text('Duplicate'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'remove',
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface),
                        child: ListTile(
                          leading: Icon(
                            LucideIcons.trash,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          title: Text('Remove'),
                        ),
                      ),
                    ],
                  ).then((value) {
                    if (value == 'edit') {
                      navigateTo(
                              context, EditPlantPage(widget.env, widget.plant))
                          .then((u) {
                        if (u != null) {
                          replaceTo(context, PlantPage(widget.env, u));
                        }
                      });
                    } else if (value == 'duplicate') {
                      _duplicatePlant();
                    } else if (value == 'remove') {
                      _deletePlant();
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
