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

class ViewSpeciesScreen extends StatefulWidget {
  final ViewSpeciesViewModel viewModel;

  const ViewSpeciesScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<ViewSpeciesScreen> createState() => _ViewSpeciesScreenState();
}

class _ViewSpeciesScreenState extends State<ViewSpeciesScreen> {
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
              title: L.of(context).errorWithMessage(command.error.toString()),
              label: L.of(context).tryAgain,
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
                                  ? L.of(context).custom
                                  : L.of(context).floraCodex,
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
                                'speciesId': widget.viewModel.id!.toString(),
                                'speciesName': widget.viewModel.scientificName,
                              }),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                                foregroundColor: WidgetStateProperty.all(
                                    Theme.of(context).colorScheme.onPrimary),
                              ),
                              child: Text(L.of(context).addToCollection),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Info
                          Text(
                            L.of(context).information,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge!,
                              children: [
                                TextSpan(
                                    text:
                                        "${widget.viewModel.scientificName} is a species of "),
                                const TextSpan(text: "genus "),
                                TextSpan(
                                  text: widget.viewModel.genus,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                const TextSpan(text: " and family "),
                                TextSpan(
                                  text: widget.viewModel.family,
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
                            'Care',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          SpeciesCareInfoGridWidget(
                              care: widget.viewModel.care, maxNum: 4),
                          const SizedBox(height: 16),

                          // Synonyms
                          Text(
                            'Synonyms',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                              "Specy is also known as: ${widget.viewModel.synonyms.join(", ")}${widget.viewModel.synonyms.isEmpty ? "" : "."}",
                              style: Theme.of(context).textTheme.bodyLarge!),
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
                              title: Text(L.of(context).edit),
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
                              title: Text(L.of(context).duplicate),
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
                              title: Text(L.of(context).remove),
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
                          await widget.viewModel.delete.executeWithFuture();
                          context.pop();
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
