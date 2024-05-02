import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/plant_add/add_plant_body.dart';
import 'package:plant_it/plant_add/header.dart';
import 'package:plant_it/toast/toast_manager.dart';

class AddPlantPage extends StatefulWidget {
  final SpeciesDTO species;
  final Environment env;

  const AddPlantPage({
    super.key,
    required this.species,
    required this.env,
  });

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  late final PlantDTO _toCreate;

  void _createPlant() async {
    try {
      int speciesId = widget.species.id ?? -1;
      if (widget.species.id == null) {
        speciesId = await _createSpecies();
      }
      _toCreate.speciesId = speciesId;
      _toCreate.info.state = "PURCHASED";
      final response = await widget.env.http.post("plant", _toCreate.toMap());
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        widget.env.logger
            .error("Error while creating plant: ${responseBody["message"]}");
        throw AppException(AppLocalizations.of(context).errorCreatingPlant);
      }
      widget.env.plants.add(PlantDTO.fromJson(responseBody));
      widget.env.logger.info("Plant successfully created");
      widget.env.toastManager.showToast(context, ToastNotificationType.success,
          AppLocalizations.of(context).plantCreatedSuccessfully);
      Navigator.pop(context, true);
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  Future<int> _createSpecies() async {
    try {
      final response =
          await widget.env.http.post("botanical-info", widget.species.toMap());
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        widget.env.logger
            .error("Error while creating species: ${responseBody["message"]}");
        throw AppException(AppLocalizations.of(context).errorCreatingSpecies);
      }
      widget.env.logger.info("Species successfully created");
      return responseBody["id"];
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  @override
  void initState() {
    super.initState();
    _toCreate = PlantDTO(info: PlantInfoDTO());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _createPlant,
        child: Icon(
          Icons.add_outlined,
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
                background: AddPlantImageHeader(
                  species: widget.species,
                  env: widget.env,
                ),
              ),
            ),
          ];
        },
        body: AddPlantBody(
          toCreate: _toCreate,
        ),
      ),
    );
  }
}
