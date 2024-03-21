import 'package:flutter/material.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/info_entries.dart';

class AddOrEditPlantBody extends StatefulWidget {
  final PlantDTO plant;
  const AddOrEditPlantBody({super.key, required this.plant});

  @override
  State<StatefulWidget> createState() => _AddOrEditPlantBodyState();
}

class _AddOrEditPlantBodyState extends State<AddOrEditPlantBody> {
  DateTime? _birthday;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 20,
      ),
      InfoGroup(title: AppLocalizations.of(context).info, children: [
        EditableSimpleInfoEntry(
          title: AppLocalizations.of(context).name,
          value: widget.plant.info.personalName,
          onChanged: (name) => widget.plant.info.personalName = name,
        ),
        EditableSwitchInfoEntry(
          title: AppLocalizations.of(context).useBirthday,
          value: widget.plant.info.startDate != null,
          onChanged: (use) {
            if (use) {
              final birthdayToUse = _birthday ?? DateTime.now();
              widget.plant.info.startDate = birthdayToUse.toString();
            } else {
              widget.plant.info.startDate = null;
            }
          },
        )
      ]),
    ]);
  }
}
