import 'package:flutter/material.dart';
import 'package:plant_it/back_button.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/plant_details/species_tab.dart';
import 'package:plant_it/search/header.dart';
import 'package:plant_it/search/species_details_bottom_bar.dart';

class SpeciesDetailsPage extends StatefulWidget {
  final Environment env;
  final SpeciesDTO species;
  final Function(SpeciesDTO) updateSpeciesLocally;

  const SpeciesDetailsPage({
    super.key,
    required this.env,
    required this.species,
    required this.updateSpeciesLocally,
  });

  @override
  State<StatefulWidget> createState() => _SpeciesDetailsPageState();
}

class _SpeciesDetailsPageState extends State<SpeciesDetailsPage> {
  void _updateSpeciesLocally(SpeciesDTO species) {
    widget.updateSpeciesLocally(species);
    fetchAndSetPlants(context, widget.env);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SpeciesDetailsBottomActionBar(
        isDeletable: widget.species.creator == "USER",
        species: widget.species,
        http: widget.env.http,
        env: widget.env,
        updateSpeciesLocally: _updateSpeciesLocally,
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
                  child: SpeciesImageHeader(
                    species: widget.species,
                    env: widget.env,
                  ),
                ),
                SpeciesDetailsTab(
                  species: widget.species,
                  isLoading: false,
                ),
              ],
            ),
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: AppBackButton(),
          ),
        ],
      ),
    );
  }
}
