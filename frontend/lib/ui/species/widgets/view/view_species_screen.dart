import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/plant/widgets/grid_widget.dart';
import 'package:plant_it/ui/species/view_models/view_species_viewmodel.dart';
import 'package:plant_it/ui/species/widgets/view/species_image.dart';
import 'package:plant_it/utils/stream_code.dart';

class ViewSpeciesScreen extends StatefulWidget {
  final ViewSpeciesViewModel viewModel;
  final StreamController<StreamCode> streamController;

  const ViewSpeciesScreen({
    super.key,
    required this.viewModel,
    required this.streamController,
  });

  @override
  State<ViewSpeciesScreen> createState() => _ViewSpeciesScreenState();
}

class _ViewSpeciesScreenState extends State<ViewSpeciesScreen> {
  
  Future<void> deleteWithConfirm() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(L.of(context).confirmDelete),
        content: Text(L.of(context).areYouSureYouWantToDeleteThisSpecies),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(L.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              await widget.viewModel.delete.executeWithFuture();
              if (widget.viewModel.delete.results.value.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(widget
                        .viewModel.delete.results.value.error
                        .toString()),
                  ),
                );
                return;
              }
              widget.streamController.add(StreamCode.deleteSpecies);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(L.of(context).speciesDeleted),
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
                        background: SpeciesImage(viewModel: widget.viewModel)),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(
                            labelPadding: EdgeInsets.all(0),
                            label: Text(
                              widget.viewModel.source ==
                                      SpeciesDataSource.custom
                                  ? appLocalizations.custom
                                  : appLocalizations.floraCodex,
                            ),
                          ),
                          Text(widget.viewModel.species,
                              style:
                                  Theme.of(context).textTheme.headlineSmall!),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.push(Routes.plant, extra: {
                                'toCreate': widget.viewModel.isExternal
                                    ? {
                                        'species': widget.viewModel.speciesObj,
                                        'care': widget.viewModel.care,
                                        'synonyms': widget.viewModel.synonyms,
                                      }
                                    : null,
                                'speciesId': widget.viewModel.id?.toString(),
                                'speciesName': widget.viewModel.scientificName,
                              }),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                                foregroundColor: WidgetStateProperty.all(
                                    Theme.of(context).colorScheme.onPrimary),
                              ),
                              child: Text(appLocalizations.addToCollection),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Info
                          Text(
                            appLocalizations.information,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          _getSpeciesInfo(),
                          const SizedBox(height: 16),

                          // Care
                          Text(
                            appLocalizations.care,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          SpeciesCareInfoGridWidget(
                            care: widget.viewModel.care,
                            maxNum: 4,
                            appLocalizations: appLocalizations,
                          ),
                          const SizedBox(height: 16),

                          // Synonyms
                          Text(
                            appLocalizations.synonyms,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          widget.viewModel.synonyms.isEmpty
                              ? Text(appLocalizations.noSynonyms,
                                  style: Theme.of(context).textTheme.bodyLarge!)
                              : Text(
                                  appLocalizations.speciesSynonyms(
                                    widget.viewModel.synonyms.join(", "),
                                    widget.viewModel.species,
                                  ),
                                  style:
                                      Theme.of(context).textTheme.bodyLarge!),
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
                            enabled: !widget.viewModel.isExternal,
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
                            enabled: !widget.viewModel.isExternal,
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
                          context
                              .push(Routes.speciesWithId(widget.viewModel.id!));
                        } else if (value == 'duplicate') {
                          await widget.viewModel.duplicate.executeWithFuture();
                        } else if (value == 'remove') {
                          await deleteWithConfirm();
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

  RichText _getSpeciesInfo() {
    String plantInfo = L.of(context).speciesClassificationInfo(
          widget.viewModel.species,
          widget.viewModel.genus ?? "",
          widget.viewModel.family ?? "",
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
          case '{species}':
            textSpans.add(TextSpan(text: widget.viewModel.species));
            break;
          case '{genus}':
            textSpans.add(TextSpan(
              text: widget.viewModel.genus,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ));
            break;
          case '{family}':
            textSpans.add(TextSpan(
              text: widget.viewModel.family,
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
