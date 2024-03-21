import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/plant_edit/add_or_edit_plant_page.dart';

class PlantDetailsBottomActionBar extends StatelessWidget {
  final PlantDTO plant;
  final Environment env;
  final Function() updatePlantLocally;

  const PlantDetailsBottomActionBar({
    super.key,
    required this.plant,
    required this.env,
    required this.updatePlantLocally,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      child: BottomAppBar(
          color: const Color.fromRGBO(24, 44, 37, 1),
          child: Row(children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_a_photo_outlined),
              color: Color.fromARGB(255, 156, 192, 172),
              tooltip: AppLocalizations.of(context).addPhotos,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.calendar_month_outlined),
              color: Color.fromARGB(255, 156, 192, 172),
              tooltip: AppLocalizations.of(context).addEvents,
            ),
            IconButton(
              onPressed: () async {
                final result =
                    await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddOrEditPlantPage(plantDTO: plant, env: env),
                ));
                if (result != null) {
                  updatePlantLocally();
                }
              },
              icon: const Icon(Icons.edit_outlined),
              color: Color.fromARGB(255, 156, 192, 172),
              tooltip: AppLocalizations.of(context).modifyPlant,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete_forever_outlined),
              color: Color.fromARGB(255, 156, 192, 172),
              tooltip: AppLocalizations.of(context).removePlant,
            ),
          ])),
    );
  }
}
