import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/event/add_new_event.dart';
import 'package:plant_it/plant_edit/edit_plant_page.dart';
import 'package:toastification/toastification.dart';

class PlantDetailsBottomActionBar extends StatelessWidget {
  final PlantDTO plant;
  final Environment env;
  final Function(PlantDTO updated) updatePlantLocally;
  final Function() refreshGallery;

  const PlantDetailsBottomActionBar({
    super.key,
    required this.plant,
    required this.env,
    required this.updatePlantLocally,
    required this.refreshGallery,
  });

  void _removePlantWithConfirm(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).pleaseConfirm),
            content: Text(AppLocalizations.of(context).areYouSureToRemovePlant),
            actions: [
              TextButton(
                onPressed: () async {
                  _removePlant(context).then((res) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(true);
                  });
                },
                child: Text(AppLocalizations.of(context).yes),
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context).no)),
            ],
          );
        });
  }

  Future<void> _removePlant(BuildContext context) async {
    try {
      final response = await env.http.delete("plant/${plant.id}");
      if (response.statusCode != 200) {
        final responseBody = json.decode(response.body);
        env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
      env.plants = env.plants.where((p) => p.id != plant.id).toList();
      env.logger.info("Plant successfully deleted");
      if (!context.mounted) return;
      showSnackbar(context, ToastificationType.success,
          AppLocalizations.of(context).plantDeletedSuccessfully);
    } catch (e, st) {
      env.logger.error(e, st);
    }
  }

  Future<void> _uploadPhotos(BuildContext context) async {
    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages.isNotEmpty) {
      for (final pickedImage in pickedImages) {
        try {
          final response = await env.http.uploadImage(pickedImage, plant.id!);
          if (response.statusCode == 200) {
            env.logger.info("Image uploaded corrrectly");
          } else {
            final responseBody = json.decode(response.body);
            env.logger.error(
                "Error while uploading image: ${responseBody["message"]}");
            throw AppException(responseBody["message"]);
          }
        } catch (e, st) {
          env.logger.error(e, st);
          throw AppException.withInnerException(e as Exception);
        }
      }
      showSnackbar(context, ToastificationType.success,
          AppLocalizations.of(context).nPhoto(pickedImages.length));
      refreshGallery();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      child: BottomAppBar(
          color: const Color.fromRGBO(24, 44, 37, 1),
          child: Row(children: [
            IconButton(
              onPressed: () => _uploadPhotos(context),
              icon: const Icon(Icons.add_a_photo_outlined),
              color: Color.fromARGB(255, 156, 192, 172),
              tooltip: AppLocalizations.of(context).addPhotos,
            ),
            IconButton(
              onPressed: () => goToPageSlidingUp(
                context,
                AddNewEventPage(
                  env: env,
                  plant: plant,
                ),
              ),
              icon: const Icon(Icons.calendar_month_outlined),
              color: Color.fromARGB(255, 156, 192, 172),
              tooltip: AppLocalizations.of(context).addEvents,
            ),
            IconButton(
              onPressed: () async {
                final updated =
                    await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditPlantPage(
                    plantDTO: PlantDTO.fromJson(plant.toMap()),
                    env: env,
                  ),
                ));
                if (updated != null) {
                  updatePlantLocally(updated);
                }
              },
              icon: const Icon(Icons.edit_outlined),
              color: Color.fromARGB(255, 156, 192, 172),
              tooltip: AppLocalizations.of(context).modifyPlant,
            ),
            const Spacer(),
            IconButton(
              onPressed: () => _removePlantWithConfirm(context),
              icon: const Icon(Icons.delete_forever_outlined),
              color: Color.fromARGB(255, 156, 192, 172),
              tooltip: AppLocalizations.of(context).removePlant,
            ),
          ])),
    );
  }
}
