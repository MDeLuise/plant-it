import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/plant/view_models/plant_view_model.dart';
import 'package:plant_it/ui/plant/widgets/grid_widget.dart';
import 'package:plant_it/ui/plant/widgets/plant_avatar.dart';
import 'package:plant_it/ui/plant/widgets/plant_gallery/plant_gallery.dart';
import 'package:plant_it/utils/stream_code.dart';

class PlantScreen extends StatefulWidget {
  final PlantViewModel viewModel;
  final StreamController<StreamCode> streamController;

  const PlantScreen({
    super.key,
    required this.viewModel,
    required this.streamController,
  });

  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _uploadNewPhoto() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    await widget.viewModel.uploadNewPhoto.executeWithFuture(pickedFile);
    setState(() {});
  }

  void deleteWithConfirm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(L.of(context).confirmDelete),
        content: Text(L.of(context).areYouSureYouWantToDeleteThisPlant),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(L.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              await widget.viewModel.deletePlant.executeWithFuture();
              if (widget.viewModel.deletePlant.results.value.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(widget
                        .viewModel.deletePlant.results.value.error
                        .toString()),
                  ),
                );
                return;
              }
              widget.streamController.add(StreamCode.deletePlant);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(L.of(context).plantDeleted),
                ),
              );
              context.pop();
              context.pop();
            },
            child: Text(L.of(context).delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    L appLocalizations = L.of(context);
    return Scaffold(
      body: ValueListenableBuilder<CommandResult<void, void>>(
        valueListenable: widget.viewModel.load.results,
        builder: (context, command, child) {
          if (command.isExecuting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (command.hasError) {
            return ErrorIndicator(
              title:
                  appLocalizations.errorWithMessage(command.error.toString()),
              label: appLocalizations.tryAgain,
              onPressed: widget.viewModel.load.execute,
            );
          }

          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * .6,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                        background: PlantAvatar(viewModel: widget.viewModel)),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
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
                            widget.viewModel.plant.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                          GestureDetector(
                            onTap: () => context.push(
                              Routes.speciesWithIdOrExternal,
                              extra: widget.viewModel.species.id,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.viewModel.species.scientificName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(width: 5),
                                Icon(LucideIcons.external_link,
                                    size: 10,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Info
                          Text(
                            appLocalizations.information,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          _getPlantInfo(),
                          const SizedBox(height: 16),

                          // Care
                          Text(
                            appLocalizations.care,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          SpeciesCareInfoGridWidget(
                            care: widget.viewModel.care.toCompanion(true),
                            maxNum: 4,
                            appLocalizations: appLocalizations,
                          ),
                          const SizedBox(height: 16),

                          // Reminder
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                appLocalizations.reminders,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              // GestureDetector(
                              //   // onTap: () => navigateTo(context,
                              //   //     ReminderListPage(widget.env, widget.plant)),
                              //   child: const Text("Edit"),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          PlantReminderInfoGridWidget(
                            viewModel: widget.viewModel,
                            maxNum: 4,
                            care: widget.viewModel.care.toCompanion(true),
                            appLocalizations: appLocalizations,
                          ),
                          const SizedBox(height: 16),

                          // Events
                          Text(
                            appLocalizations.events,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          PlantEventInfoGridWidget(
                            viewModel: widget.viewModel,
                            maxNum: 4,
                            care: widget.viewModel.care.toCompanion(true),
                            appLocalizations: appLocalizations,
                          ),
                          const SizedBox(height: 16),

                          // Additional info
                          Text(
                            appLocalizations.additionalInfo,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          if (widget.viewModel.plant.seller != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  appLocalizations.seller,
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                                Text(
                                  widget.viewModel.plant.seller!,
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                              ],
                            ),
                          if (widget.viewModel.plant.price != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  appLocalizations.price,
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                                Text(
                                  widget.viewModel.plant.price!.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                              ],
                            ),
                          if (widget.viewModel.plant.location != null)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  appLocalizations.location,
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                                Text(
                                  widget.viewModel.plant.location!,
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                              ],
                            ),
                          const SizedBox(height: 16),

                          // Gallery
                          Text(
                            appLocalizations.gallery,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          PlantGallery(
                            viewModel: widget.viewModel,
                            allowUpload: true,
                            onUpload: _uploadNewPhoto,
                            reload: () => setState(() {}),
                            streamController: widget.streamController,
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
                child: Card(
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
                child: Card(
                  child: IconButton(
                    onPressed: () {
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
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
                              title: Text(appLocalizations.edit),
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
                              title: Text(appLocalizations.duplicate),
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
                              title: Text(appLocalizations.remove),
                            ),
                          ),
                        ],
                      ).then((value) async {
                        if (value == 'edit') {
                          context.push(
                              Routes.editPlantWithId(widget.viewModel.id));
                        } else if (value == 'duplicate') {
                          Command<void, void> command =
                              widget.viewModel.duplicatePlant;
                          await command.executeWithFuture();
                          if (command.results.value.hasError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    command.results.value.error.toString()),
                              ),
                            );
                          } else {
                            widget.streamController.add(StreamCode.insertPlant);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(appLocalizations.plantDuplicated),
                              ),
                            );
                          }
                        } else if (value == 'remove') {
                          deleteWithConfirm();
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
          );
        },
      ),
    );
  }

  RichText _getPlantInfo() {
    String plantInfo = L.of(context).plantClassificationInfo(
          widget.viewModel.plant.name,
          widget.viewModel.species.species,
          widget.viewModel.species.genus ?? "",
          widget.viewModel.species.family ?? "",
        );

    List<TextSpan> textSpans = [];
    RegExp regExp = RegExp(
        r'(\|.*?\|)|(\{name\}|\{species\}|\{genus\}|\{family\})|([^|{}]+)');
    Iterable<Match> matches = regExp.allMatches(plantInfo);
    int lastMatchEnd = 0;

    for (Match match in matches) {
      if (lastMatchEnd < match.start) {
        textSpans.add(
            TextSpan(text: plantInfo.substring(lastMatchEnd, match.start)));
      }

      if (match.group(1) != null) {
        String matchedText = match.group(1)!.replaceAll('|', '');
        textSpans.add(TextSpan(
          text: matchedText,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ));
      } else if (match.group(2) != null) {
        String matchedPlaceholder = match.group(2)!;
        switch (matchedPlaceholder) {
          case '{name}':
            textSpans.add(TextSpan(text: widget.viewModel.plant.name));
            break;
          case '{species}':
            textSpans.add(TextSpan(text: widget.viewModel.species.species));
            break;
          case '{genus}':
            textSpans.add(TextSpan(
              text: widget.viewModel.species.genus,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ));
            break;
          case '{family}':
            textSpans.add(TextSpan(
              text: widget.viewModel.species.family,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ));
            break;
        }
      } else if (match.group(3) != null) {
        textSpans.add(TextSpan(text: match.group(3)));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < plantInfo.length) {
      textSpans.add(TextSpan(text: plantInfo.substring(lastMatchEnd)));
    }

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge,
        children: textSpans,
      ),
    );
  }
}
