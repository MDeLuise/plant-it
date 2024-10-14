import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/species_edit/edit_species_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/species_edit/header.dart';
import 'package:plant_it/toast/toast_manager.dart';

class EditSpeciesPage extends StatefulWidget {
  final SpeciesDTO species;
  final Environment env;

  const EditSpeciesPage({
    super.key,
    required this.species,
    required this.env,
  });

  @override
  State<EditSpeciesPage> createState() => _EditSpeciesPageState();
}

class _EditSpeciesPageState extends State<EditSpeciesPage> {
  void _editSpecies() async {
    widget.species.creator = "USER";
    try {
      Response response;
      if (widget.species.id == null) {
        response = await widget.env.http.post(
          "botanical-info",
          widget.species.toMap(),
        );
      } else {
        response = await widget.env.http.put(
          "botanical-info/${widget.species.id}",
          widget.species.toMap(),
        );
      }
      final responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode != 200) {
        widget.env.logger
            .error("Error while updating species: ${responseBody["message"]}");
        if (!mounted) return;
        throw AppException(AppLocalizations.of(context).errorUpdatingSpecies);
      }
      final SpeciesDTO updatedSpecies = SpeciesDTO.fromJson(responseBody);
      widget.env.logger.info("Species successfully updated");
      if (!mounted) return;
      widget.env.toastManager.showToast(
        context,
        ToastNotificationType.success,
        AppLocalizations.of(context).speciesUpdatedSuccessfully,
      );
      Navigator.pop(context, updatedSpecies);
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _editSpecies,
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
                  child: EditSpeciesImageHeader(
                    species: widget.species,
                    env: widget.env,
                  ),
                ),
                EditSpeciesBody(
                  species: widget.species,
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
