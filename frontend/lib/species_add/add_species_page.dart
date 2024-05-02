import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/search/species_details_page.dart';
import 'package:plant_it/species_add/add_species_body.dart';
import 'package:plant_it/species_add/header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/toast/toast_manager.dart';

class AddSpeciesPage extends StatefulWidget {
  final String? name;
  final Environment env;

  const AddSpeciesPage({
    super.key,
    this.name,
    required this.env,
  });

  @override
  State<AddSpeciesPage> createState() => _AddSpeciesPageState();
}

class _AddSpeciesPageState extends State<AddSpeciesPage> {
  late final SpeciesDTO _toCreate;

  @override
  void initState() {
    super.initState();
    _toCreate = SpeciesDTO(
      scientificName: widget.name ?? "",
      species: widget.name ?? "",
      care: SpeciesCareInfoDTO(),
      creator: "USER",
    );
  }

  void _createSpecies() async {
    try {
      final response = await widget.env.http.post(
        "botanical-info",
        _toCreate.toMap(),
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        widget.env.logger
            .error("Error while creating species: ${responseBody["message"]}");
        throw AppException(AppLocalizations.of(context).errorCreatingSpecies);
      }
      final SpeciesDTO updatedSpecies = SpeciesDTO.fromJson(responseBody);
      widget.env.logger.info("Species successfully created");
      widget.env.toastManager.showToast(
        context,
        ToastNotificationType.success,
        AppLocalizations.of(context).speciesCreatedSuccessfully,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SpeciesDetailsPage(
            env: widget.env,
            species: updatedSpecies,
          ),
        ),
      );
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _createSpecies,
        child: Icon(
          Icons.save_outlined,
        ),
      ),
      body: NestedScrollViewPlus(
        overscrollBehavior: OverscrollBehavior.outer,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: MediaQuery.of(context).size.height * .3,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
                background: AddSpeciesImageHeader(
                  species: _toCreate,
                  env: widget.env,
                ),
              ),
            ),
          ];
        },
        body: AddSpeciesBody(
          species: _toCreate,
        ),
      ),
    );
  }
}
