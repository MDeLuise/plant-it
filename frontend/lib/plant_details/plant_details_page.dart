import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';
import 'package:plant_it/plant_details/plant_details_bottom_bar.dart';
import 'package:plant_it/plant_details/header.dart';
import 'package:plant_it/plant_details/plant_tab.dart';
import 'package:plant_it/plant_details/sliver_persistent_header_delegate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/plant_details/species_tab.dart';

class PlantDetailsPage extends StatefulWidget {
  final Environment env;
  final PlantDTO plant;

  const PlantDetailsPage({
    super.key,
    required this.env,
    required this.plant,
  });

  @override
  State<StatefulWidget> createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  late final SpeciesDTO _species;
  late PlantDetailsTab _plantDetailsTab;
  late PlantDTO _toShow;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _toShow = widget.plant;
    _plantDetailsTab = _createPlantDetailsChild();
    _fetchAndSetSpecies();
  }

  // Used only for refresh the Gallery
  PlantDetailsTab _createPlantDetailsChild() {
    return PlantDetailsTab(
      key: UniqueKey(),
      plant: _toShow,
      http: widget.env.http,
      env: widget.env,
    );
  }

  void _updatePlantLocally(PlantDTO updated) {
    widget.env.plants = widget.env.plants.map((pl) {
      if (pl.id != updated.id) {
        return pl;
      }
      return updated;
    }).toList();
    setState(() {
      _toShow = updated;
      _plantDetailsTab = _createPlantDetailsChild();
    });
  }

  void _refreshGallery() {
    setState(() => _plantDetailsTab = _createPlantDetailsChild());
  }

  void _fetchAndSetSpecies() async {
    try {
      final response =
          await widget.env.http.get("botanical-info/${widget.plant.speciesId}");
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        if (!mounted) return;
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
      _species = SpeciesDTO.fromJson(responseBody);
      setState(() {
        _isLoading = false;
      });
    } catch (e, st) {
      if (!mounted) return;
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: PlantDetailsBottomActionBar(
          plant: _toShow,
          env: widget.env,
          updatePlantLocally: _updatePlantLocally,
          refreshGallery: _refreshGallery,
        ),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollViewPlus(
            overscrollBehavior: OverscrollBehavior.outer,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  iconTheme: const IconThemeData(
                    shadows: [
                      BoxShadow(
                        color: Colors.black,
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  pinned: true,
                  stretch: true,
                  expandedHeight: MediaQuery.of(context).size.height * .5,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                    ],
                    background: PlantImageHeader(
                      plant: _toShow,
                      env: widget.env,
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: PlantDetailsPersistentHeaderDelegate(
                    TabBar(
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          text: AppLocalizations.of(context).plant,
                        ),
                        Tab(
                          text: AppLocalizations.of(context).species,
                        ),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: [
                _plantDetailsTab,
                SpeciesDetailsTab(
                  species: _isLoading
                      ? SpeciesDTO(
                          scientificName: "foo",
                          care: SpeciesCareInfoDTO(),
                          creator: "USER")
                      : _species,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ));
  }
}
