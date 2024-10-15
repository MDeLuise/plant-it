import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/floating_tabbar.dart';
import 'package:plant_it/plant_details/details_tab.dart';
import 'package:plant_it/plant_details/plant_details_bottom_bar.dart';
import 'package:plant_it/plant_details/header.dart';
import 'package:plant_it/plant_details/plant_tab.dart';
import 'package:plant_it/plant_details/species_tab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late Widget _activeTab;

  @override
  void initState() {
    super.initState();
    _toShow = widget.plant;
    _plantDetailsTab = _createPlantDetailsChild();
    _fetchAndSetSpecies();
    _activeTab = DetailsTab(plant: _toShow, env: widget.env);
  }

  // Used only for refresh the Gallery
  PlantDetailsTab _createPlantDetailsChild() {
    return PlantDetailsTab(
      key: UniqueKey(),
      plant: _toShow,
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
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * .5,
                    maxHeight: MediaQuery.of(context).size.height * .5,
                  ),
                  child: PlantImageHeader(
                    plant: _toShow,
                    env: widget.env,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Column(
                    children: [
                      FloatingTabBar(
                        titles: [
                          AppLocalizations.of(context).activity, // or "Tasks"
                          AppLocalizations.of(context).plant,
                          AppLocalizations.of(context).species,
                        ],
                        callbacks: [
                          () => setState(() => _activeTab = DetailsTab(
                                key: UniqueKey(),
                                plant: _toShow,
                                env: widget.env,
                              )),
                          () => setState(() => _activeTab = _plantDetailsTab),
                          () => setState(() => _activeTab = SpeciesDetailsTab(
                                species: _isLoading
                                    ? SpeciesDTO(
                                        scientificName: "foo",
                                        care: SpeciesCareInfoDTO(),
                                        creator: "USER")
                                    : _species,
                                isLoading: _isLoading,
                              )),
                        ],
                      ),
                      _activeTab,
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
