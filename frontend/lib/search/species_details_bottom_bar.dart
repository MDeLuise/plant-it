import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/species_dto.dart';

class SpeciesDetailsBottomActionBar extends StatelessWidget {
  final AppHttpClient http;
  final bool isDeletable;
  final SpeciesDTO species;
  const SpeciesDetailsBottomActionBar({
    super.key,
    required this.isDeletable,
    required this.http,
    required this.species,
  });

  void _removeSpeciesWithConfirm(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).confirm),
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
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        showSnackbar(context, SnackBarType.fail, responseBody["message"]);
        return;
      }
    } catch (e) {
      showSnackbar(context, SnackBarType.fail, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 24,
                    color: Color.fromARGB(255, 224, 224, 224),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).addPlant,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 224, 224, 224),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
              color: Color.fromARGB(255, 156, 192, 172),
              tooltip: AppLocalizations.of(context).modifyPlant,
            ),
            if (isDeletable)
              IconButton(
                onPressed: () => _removeSpeciesWithConfirm(context),
                icon: const Icon(Icons.delete_forever_outlined),
                color: Color.fromARGB(255, 156, 192, 172),
                tooltip: AppLocalizations.of(context).removePlant,
              ),
          ])),
    );
  }
}
