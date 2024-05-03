import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/plant_add/add_plant_page.dart';
import 'package:plant_it/search/species_details_page.dart';
import 'package:plant_it/species_edit/edit_species_page.dart';

class SpeciesDetailsBottomActionBar extends StatelessWidget {
  final AppHttpClient http;
  final bool isDeletable;
  final SpeciesDTO species;
  final Environment env;

  const SpeciesDetailsBottomActionBar({
    super.key,
    required this.isDeletable,
    required this.http,
    required this.species,
    required this.env,
  });

  void _removeSpeciesWithConfirm(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).pleaseConfirm),
            content:
                Text(AppLocalizations.of(context).areYouSureToRemoveSpecies),
            actions: [
              TextButton(
                onPressed: () {
                  _removeSpecies(context);
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context).yes),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context).no),
              ),
            ],
          );
        });
  }

  void _removeSpecies(BuildContext context) async {
    try {
      final response = await http.delete(
        "botanical-info/${species.id}",
      );
      if (!context.mounted) return;
      if (response.statusCode != 200) {
        final responseBody = json.decode(response.body);
        env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
    } catch (e, st) {
      env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
      child: BottomAppBar(
          //shape: const CircularNotchedRectangle(),
          //notchMargin: 80.0,
          color: const Color.fromRGBO(24, 44, 37, 1),
          child: Row(children: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPlantPage(
                      env: env,
                      species: species,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      size: 24,
                      color: Color.fromARGB(255, 24, 24, 24),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context).addPlant,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 24, 24, 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                final updated =
                    await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditSpeciesPage(
                    species: SpeciesDTO.fromJson(species.toMap()),
                    env: env,
                  ),
                ));
                if (updated != null) {
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SpeciesDetailsPage(
                      species: updated,
                      env: env,
                    ),
                  ));
                }
              },
              icon: const Icon(Icons.edit_outlined),
              color: const Color.fromARGB(255, 156, 192, 172),
              tooltip: AppLocalizations.of(context).modifyPlant,
            ),
            if (isDeletable)
              IconButton(
                onPressed: () => _removeSpeciesWithConfirm(context),
                icon: const Icon(Icons.delete_forever_outlined),
                color: const Color.fromARGB(255, 156, 192, 172),
                tooltip: AppLocalizations.of(context).removePlant,
              ),
          ])),
    );
  }
}
