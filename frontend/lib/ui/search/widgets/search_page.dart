import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/search/view_models/search_viewmodel.dart';
import 'package:plant_it/ui/search/widgets/species_card.dart';

class SearchPage extends StatefulWidget {
  final SearchViewModel viewModel;

  const SearchPage({
    super.key,
    required this.viewModel,
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
                title: "Error",
                label: "Try again",
                onPressed: widget.viewModel.search.execute,
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: SearchBar(
                        controller: _searchController,
                        hintText: "Search green friends",
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
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, size: 25),
                            onSelected: (value) async {
                              if (value == 'add') {
                                // ...
                              } else if (value == 'filter') {
                                // ...
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'add',
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.plus),
                                    SizedBox(width: 10),
                                    Text('Create'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'filter',
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(LucideIcons.filter),
                                    SizedBox(width: 10),
                                    Text('Filter'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                  ...List.generate(widget.viewModel.result.length, (index) {
                    SpeciesSearcherResult species =
                        widget.viewModel.result[index];
                    return SpeciesCard(
                      speciesSearcherResult: species,
                      viewModel: widget.viewModel,
                    );
                  }),
                ],
              ),
            );
          }),
    );
  }
}
