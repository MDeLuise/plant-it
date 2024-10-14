import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  late Future<String> _initialPlantName;

  Future<String> _getAndSetInitialPlantName() async {
    final String scientificName = widget.species.scientificName;
    if (widget.species.id == null) {
      _toCreate.info.personalName = scientificName;
      return scientificName;
    }
    try {
      final response = await widget.env.http
          .get("botanical-info/${widget.species.id}/_count");
      if (response.statusCode != 200) {
        final responseBody = json.decode(utf8.decode(response.bodyBytes));
        widget.env.logger.error(
            "Error while getting plant name: ${responseBody["message"]}");
        if (!mounted) return Future.value(scientificName);
        throw AppException(AppLocalizations.of(context).generalError);
      }
      final String name =
          "$scientificName${response.body == "0" ? "" : " ${response.body}"}";
      _toCreate.info.personalName = name;
      return name;
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  void _createPlant() async {
    try {
      int speciesId = widget.species.id ?? -1;
      if (widget.species.id == null) {
        speciesId = await _createSpecies();
      }
      _toCreate.speciesId = speciesId;
      _toCreate.info.state = "PURCHASED";
      final response = await widget.env.http.post("plant", _toCreate.toMap());
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        widget.env.logger
            .error("Error while creating plant: ${responseBody["message"]}");
        if (!mounted) return;
        throw AppException(AppLocalizations.of(context).errorCreatingPlant);
      }
      widget.env.plants.add(PlantDTO.fromJson(responseBody));
      widget.env.logger.info("Plant successfully created");
      if (!mounted) return;
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
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        widget.env.logger
            .error("Error while creating species: ${responseBody["message"]}");
        if (!mounted) throw AppException("Context not mounted, error.");
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
    _initialPlantName = _getAndSetInitialPlantName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _createPlant,
        child: const Icon(
          Icons.add_outlined,
        ),
      ),
      body: FutureBuilder<String>(
        future: _initialPlantName,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            _toCreate.info.personalName = snapshot.data!;
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * .3,
                          maxHeight: MediaQuery.of(context).size.height * .3,
                        ),
                        child: AddPlantImageHeader(
                          species: widget.species,
                          env: widget.env,
                        ),
                      ),
                      AddPlantBody(toCreate: _toCreate),
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
            );
          } else {
            return const Center(child: Text('Unexpected error'));
          }
        },
      ),
    );
  }
}
