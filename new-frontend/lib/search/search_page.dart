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

  bool _isFilterActive() {
    return _filteredDataSource.length != _enabledDataSource.length;
  }

  void _clearSearch() {
    _searchController.clear();
    _fetchSpecies('');
  }

  void _showFilterDialog() async {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SearchFilter(widget.env, ((dataSources) async {
          final SpeciesFetcherFacade newSpeciesFetcherFacade =
              SpeciesFetcherFacade();
          for (DataSourceFilterType dataSource in dataSources) {
            if (dataSource == DataSourceFilterType.custom) {
              newSpeciesFetcherFacade.addNext(CustomFetcher(widget.env));
            } else if (dataSource == DataSourceFilterType.floraCodex) {
              final String floraCodexApi = await _setAndGetFloraCodexApiKey();
              newSpeciesFetcherFacade.addNext(FloraCodexFetcher(floraCodexApi));
            } else if (dataSource == DataSourceFilterType.trefle) {
              newSpeciesFetcherFacade.addNext(TrefleFetcher(widget.env));
            }
          }
          setState(() {
            _filteredDataSource = dataSources;
            _speciesFetcherFacade = newSpeciesFetcherFacade;
          });
        }), _enabledDataSource, _filteredDataSource);
      },
    );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: _showFilterDialog,
                icon: const Icon(LucideIcons.filter),
              ),
              if (_isFilterActive())
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: () => navigateTo(
                context,
                AddSpeciesPage(
                  widget.env,
                  name: _searchController.text,
                )),
            icon: const Icon(LucideIcons.plus),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search new green friends",
                  prefixIcon: const Icon(LucideIcons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(LucideIcons.x),
                          onPressed: _clearSearch,
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
        ),
      ),
    );
  }
}
