import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';
import 'package:plant_it/plant_details/bottom_bar.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndSetSpecies();
  }

  void _fetchAndSetSpecies() async {
    try {
      final response =
          await widget.env.http.get("botanical-info/${widget.plant.speciesId}");
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        showSnackbar(context, SnackBarType.fail, responseBody["message"]);
        return;
      }
      _species = SpeciesDTO.fromJson(responseBody);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      showSnackbar(context, SnackBarType.fail, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const BottomActionBar(),
        body: DefaultTabController(
          length: 2,
          child: NestedScrollViewPlus(
            overscrollBehavior: OverscrollBehavior.outer,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  // actions: [
                  //   IconButton(
                  //     icon: const Icon(Icons.delete_forever_outlined),
                  //     tooltip: 'Remove plant',
                  //     onPressed: () {},
                  //   )
                  // ],
                  pinned: true,
                  stretch: true,
                  expandedHeight: MediaQuery.of(context).size.height * .5,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const <StretchMode>[
                      StretchMode.zoomBackground,
                      StretchMode.blurBackground,
                    ],
                    //title: Text('Goa', textScaleFactor: 1),
                    background:
                        PlantImageHeader(plant: widget.plant, env: widget.env),
                  ),
                  //collapsedHeight: 100,
                ),
                SliverPersistentHeader(
                  delegate: MySliverPersistentHeaderDelegate(
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
                PlantDetailsTab(
                  plant: widget.plant,
                  http: widget.env.http,
                ),
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
