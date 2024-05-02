import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';
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
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        widget.env.logger
            .error("Error while updating species: ${responseBody["message"]}");
        throw AppException(AppLocalizations.of(context).errorUpdatingSpecies);
      }
      final SpeciesDTO updatedSpecies = SpeciesDTO.fromJson(responseBody);
      widget.env.logger.info("Species successfully updated");
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
                background: EditSpeciesImageHeader(
                  species: widget.species,
                  env: widget.env,
                ),
              ),
            ),
          ];
        },
        body: EditSpeciesBody(
          species: widget.species,
        ),
      ),
    );
  }
}
