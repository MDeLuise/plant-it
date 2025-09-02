import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_it/l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<CommandResult<void, void>>(
        valueListenable: widget.viewModel.load.results,
        builder: (context, command, child) {
          if (command.isExecuting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (command.hasError) {
            return ErrorIndicator(
              title: AppLocalizations.of(context)!.errorWithMessage(command.error.toString()),
              label: AppLocalizations.of(context)!.tryAgain,
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
                            AppLocalizations.of(context)!.information,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge!,
                              children: [
                                TextSpan(
                                    text:
                                        "${widget.viewModel.plant.name} is a plant of the species "),
                                TextSpan(
                                  text: widget.viewModel.species.species,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                const TextSpan(text: ", genus "),
                                TextSpan(
                                  text: widget.viewModel.species.genus,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                const TextSpan(text: " and family "),
                                TextSpan(
                                  text: widget.viewModel.species.family,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                const TextSpan(text: "."),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Care
                          Text(
                            AppLocalizations.of(context)!.care,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          SpeciesCareInfoGridWidget(
                              care: widget.viewModel.care.toCompanion(true),
                              maxNum: 4),
                          const SizedBox(height: 16),

                          // Reminder
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.reminders,
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
                          ),
                          const SizedBox(height: 16),

                          // Events
                          Text(
                            AppLocalizations.of(context)!.events,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          PlantEventInfoGridWidget(
                            viewModel: widget.viewModel,
                            maxNum: 4,
                            care: widget.viewModel.care.toCompanion(true),
                          ),
                          const SizedBox(height: 16),

                          // Gallery
                          Text(
                            AppLocalizations.of(context)!.gallery,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          PlantGallery(
                            viewModel: widget.viewModel,
                            allowUpload: true,
                            onUpload: _uploadNewPhoto,
                            reload: () => setState(() {}),
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
                              title: Text(AppLocalizations.of(context)!.edit),
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
                              title: Text(AppLocalizations.of(context)!.duplicate),
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
                              title: Text(AppLocalizations.of(context)!.remove),
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
                                content: Text(AppLocalizations.of(context)!.plantDuplicated),
                              ),
                            );
                          }
                        } else if (value == 'remove') {
                          Command<void, void> command =
                              widget.viewModel.deletePlant;
                          await command.executeWithFuture();
                          if (command.results.value.hasError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    command.results.value.error.toString()),
                              ),
                            );
                          } else {
                            widget.streamController.add(StreamCode.deletePlant);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.plantDeleted),
                              ),
                            );
                            context.pop();
                          }
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
}
