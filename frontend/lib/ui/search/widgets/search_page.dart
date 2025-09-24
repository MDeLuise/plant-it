import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/search/view_models/search_viewmodel.dart';
import 'package:plant_it/ui/search/widgets/empty_search.dart';
import 'package:plant_it/ui/search/widgets/species_card.dart';
import 'package:plant_it/utils/stream_code.dart';

class SearchPage extends StatefulWidget {
  final SearchViewModel viewModel;
  final StreamController<StreamCode> streamController;

  const SearchPage({
    super.key,
    required this.viewModel,
    required this.streamController,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        widget.viewModel.search.execute(
          Query(
            term: "",
            offset: 0,
            limit: 10,
          ),
        );
      }
    });
    widget.streamController.stream.listen((_) {
      widget.viewModel.search.execute(
        Query(
            term: "",
            offset: 0,
            limit: 10,
          ),
      );
    });
  }

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      widget.viewModel.search.execute(
        Query(
          term: value,
          offset: 0,
          limit: 10,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: ValueListenableBuilder<CommandResult<Query?, void>>(
          valueListenable: widget.viewModel.search.results,
          builder: (context, command, _) {
            if (command.isExecuting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (command.hasError) {
              return ErrorIndicator(
                title: L.of(context).errorWithMessage(command.error.toString()),
                label: L.of(context).tryAgain,
                onPressed: widget.viewModel.search.execute,
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: SearchBar(
                        controller: _searchController,
                        hintText: L.of(context).searchGreenFriends,
                        leading: const Icon(Icons.search),
                        elevation: WidgetStatePropertyAll(0),
                        padding: const WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        onSubmitted: _onSearchSubmitted,
                        trailing: [
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                              },
                            ),
                          IconButton(
                            icon: const Icon(LucideIcons.plus),
                            onPressed: () => context.push(
                              Routes.species,
                              extra: _searchController.text,
                            ),
                          ),
                          // PopupMenuButton<String>(
                          //   icon: const Icon(Icons.more_vert, size: 25),
                          //   onSelected: (value) async {
                          //     if (value == 'add') {
                          //       context.push(Routes.species, extra: _searchController.text);
                          //     } else if (value == 'filter') {
                          //       // ...
                          //     }
                          //   },
                          //   itemBuilder: (BuildContext context) => [
                          //     const PopupMenuItem(
                          //       value: 'add',
                          //       child: Row(
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         children: [
                          //           Icon(LucideIcons.plus),
                          //           SizedBox(width: 10),
                          //           Text('Create'),
                          //         ],
                          //       ),
                          //     ),
                          //     const PopupMenuItem(
                          //       value: 'filter',
                          //       child: Row(
                          //         crossAxisAlignment: CrossAxisAlignment.center,
                          //         children: [
                          //           Icon(LucideIcons.filter),
                          //           SizedBox(width: 10),
                          //           Text('Filter'),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ]),
                  ),
                  widget.viewModel.result.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - 300,
                            child: Center(
                              child: EmptySearch(
                                  searchedSpecies: _searchController.text),
                            ),
                          ),
                        )
                      : SizedBox(),
                  ...List.generate(widget.viewModel.result.length, (index) {
                    SpeciesSearcherPartialResult species =
                        widget.viewModel.result[index];
                    dynamic idOrExternal =
                        species.speciesCompanion.dataSource.value ==
                                SpeciesDataSource.custom
                            ? species.speciesCompanion.id.value
                            : species;
                    return GestureDetector(
                      onTap: () => context.push(Routes.speciesWithIdOrExternal,
                          extra: idOrExternal),
                      child: SpeciesCard(
                        key: UniqueKey(),
                        speciesSearcherResult: species,
                        viewModel: widget.viewModel,
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
    );
  }
}
