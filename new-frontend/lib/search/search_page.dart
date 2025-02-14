import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/search/fetcher/flora_codex/flora_codex_fetcher.dart';
import 'package:plant_it/search/fetcher/custom/custom_fetcher.dart';
import 'package:plant_it/search/fetcher/trefle/trefle_fetcher.dart';
import 'package:plant_it/search/search_filter.dart';
import 'package:plant_it/search/search_species_card.dart';
import 'package:plant_it/search/fetcher/species_fetcher.dart';
import 'package:plant_it/search/species/add_species_page.dart';

class SearchPage extends StatefulWidget {
  final Environment env;

  const SearchPage(this.env, {super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late SpeciesFetcherFacade _speciesFetcherFacade;
  List<SpeciesCompanion> _fetched = [];
  bool _isLoading = false;
  Timer? _debounceTimer;
  final List<DataSourceFilterType> _enabledDataSource = [
    DataSourceFilterType.custom
  ];
  List<DataSourceFilterType> _filteredDataSource = [
    DataSourceFilterType.custom
  ];
  String? _floraCodexApiKey;

  void _clearSearch() {
    _searchController.clear();
    _fetchSpecies('');
  }

  void _showFilterDialog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: .4,
          maxChildSize: .5,
          expand: false,
          shouldCloseOnMinExtent: true,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SearchFilter(
                widget.env,
                (dataSources) async {
                  final newFetcher =
                      await _createFetcherFromDataSources(dataSources);
                  setState(() {
                    _filteredDataSource = dataSources;
                    _speciesFetcherFacade = newFetcher;
                  });
                },
                _enabledDataSource,
                _filteredDataSource,
              ),
            );
          },
        );
      },
    );
  }

  Future<SpeciesFetcherFacade> _createFetcherFromDataSources(
      List<DataSourceFilterType> dataSources) async {
    final newFetcher = SpeciesFetcherFacade();

    for (var dataSource in dataSources) {
      switch (dataSource) {
        case DataSourceFilterType.custom:
          newFetcher.addNext(CustomFetcher(widget.env));
          break;
        case DataSourceFilterType.floraCodex:
          final apiKey = await _setAndGetFloraCodexApiKey();
          newFetcher.addNext(FloraCodexFetcher(apiKey));
          break;
        case DataSourceFilterType.trefle:
          newFetcher.addNext(TrefleFetcher(widget.env));
          break;
      }
    }
    return newFetcher;
  }

  Future<String> _setAndGetFloraCodexApiKey() async {
    if (_floraCodexApiKey == null) {
      await widget.env.userSettingRepository
          .getOrDefault("dataSource_floraCodex_apiKey", '')
          .then((a) {
        _floraCodexApiKey = a;
      });
    }
    return Future.value(_floraCodexApiKey);
  }

  @override
  void initState() {
    super.initState();

    _speciesFetcherFacade = SpeciesFetcherFacade();
    _speciesFetcherFacade.addNext(CustomFetcher(widget.env));
    _fetchSpecies('');

    widget.env.userSettingRepository
        .getOrDefault("dataSource_floraCodex_enabled", "false")
        .then((e) {
      if (e == 'true') {
        _enabledDataSource.add(DataSourceFilterType.floraCodex);
        _filteredDataSource.add(DataSourceFilterType.floraCodex);
        _setAndGetFloraCodexApiKey().then((a) {
          _speciesFetcherFacade.addNext(FloraCodexFetcher(a));
        });
      }

      widget.env.speciesRepository.existsTrefle().then((e) {
        if (e) {
          _enabledDataSource.add(DataSourceFilterType.trefle);
          _filteredDataSource.add(DataSourceFilterType.trefle);
          _speciesFetcherFacade.addNext(TrefleFetcher(widget.env));
        }
      });
    });

    _searchController.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _fetchSpecies(_searchController.text);
      });
    });
  }

  void _fetchSpecies(String query) {
    setState(() {
      _isLoading = true;
    });

    _speciesFetcherFacade.fetch(query, Pageable()).then((r) {
      setState(() {
        _fetched = r;
        _isLoading = false;
      });
    }).catchError((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.shadow,
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "i.e. Strelitzia nicolai",
                        filled: true,
                        prefixIcon: const Icon(LucideIcons.search),
                        suffixIcon: SizedBox(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: _showFilterDialog,
                                icon:
                                    const Icon(LucideIcons.sliders_horizontal),
                              ),
                              ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _searchController,
                                builder: (context, value, child) {
                                  return value.text.isNotEmpty
                                      ? IconButton(
                                          icon:
                                              const Icon(LucideIcons.circle_x),
                                          onPressed: _clearSearch,
                                        )
                                      : const SizedBox();
                                },
                              ),
                            ],
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () => navigateTo(
                      context,
                      AddSpeciesPage(
                        widget.env,
                        name: _searchController.text,
                      )),
                  icon: const Icon(LucideIcons.plus),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _fetched.isEmpty
                  ? const Center(
                      child: Text("No results found."),
                    )
                  : ListView.builder(
                      itemCount: _fetched.length,
                      itemBuilder: (context, index) {
                        return SearchSpeciesCard(
                          widget.env,
                          _fetched[index],
                          _speciesFetcherFacade,
                          key: UniqueKey(),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
