import 'package:flutter/material.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';
import 'package:plant_it/plant_details/species_tab.dart';
import 'package:plant_it/search/header.dart';
import 'package:plant_it/search/species_details_bottom_bar.dart';

class SpeciesDetailsPage extends StatefulWidget {
  final Environment env;
  final SpeciesDTO species;

  const SpeciesDetailsPage({
    super.key,
    required this.env,
    required this.species,
  });

  @override
  State<StatefulWidget> createState() => _SpeciesDetailsPageState();
}

class _SpeciesDetailsPageState extends State<SpeciesDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: SpeciesDetailsBottomActionBar(
          isDeletable: widget.species.creator == "USER",
          species: widget.species,
          http: widget.env.http,
          env: widget.env,
        ),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollViewPlus(
            overscrollBehavior: OverscrollBehavior.outer,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  stretch: true,
                  expandedHeight: MediaQuery.of(context).size.height * .5,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                    ],
                    background: SpeciesImageHeader(
                        species: widget.species, env: widget.env),
                  ),
                ),
              ];
            },
            body: SpeciesDetailsTab(
              species: widget.species,
              isLoading: false,
            ),
          ),
        ));
  }
}
