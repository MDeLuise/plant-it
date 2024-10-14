import 'dart:convert';

import 'package:flutter/material.dart';
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
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        widget.env.logger
            .error("Error while creating species: ${responseBody["message"]}");
        if (!mounted) return;
        throw AppException(AppLocalizations.of(context).errorCreatingSpecies);
      }
      final SpeciesDTO updatedSpecies = SpeciesDTO.fromJson(responseBody);
      widget.env.logger.info("Species successfully created");
      if (!mounted) return;
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
        child: const Icon(
          Icons.save_outlined,
        ),
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
                  child: AddSpeciesImageHeader(
                    species: _toCreate,
                    env: widget.env,
                  ),
                ),
                AddSpeciesBody(species: _toCreate),
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
