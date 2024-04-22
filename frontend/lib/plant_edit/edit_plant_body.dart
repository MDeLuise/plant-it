import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/info_entries.dart';

class EditPlantBody extends StatefulWidget {
  final PlantDTO plant;

  const EditPlantBody({
    super.key,
    required this.plant,
  });

  @override
  State<StatefulWidget> createState() => _EditPlantBodyState();
}

class _EditPlantBodyState extends State<EditPlantBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          EditableSimpleInfoEntry(
            title: AppLocalizations.of(context).name,
            value: widget.plant.info.personalName,
            onChanged: (name) => widget.plant.info.personalName = name,
            onlyNumber: false,
          ),
          EditableDateInfoEntry(
            title: AppLocalizations.of(context).birthday,
            emptyHint: AppLocalizations.of(context).noBirthday,
            value: widget.plant.info.startDate != null
                ? DateTime.parse(widget.plant.info.startDate!)
                : null,
            onChange: (d) {
              if (d != null) {
                widget.plant.info.startDate = d.toIso8601String();
              } else {
                widget.plant.info.startDate = null;
              }
            },
          ),
          EditableAvatarMode(
            mode: widget.plant.avatarMode!,
            onChangeValue: (m) => widget.plant.avatarMode = m,
            title: AppLocalizations.of(context).avatar,
          ),
          EditableCurrencyInfoEntry(
            currency: widget.plant.info.currencySymbol,
            title: AppLocalizations.of(context).purchasedPrice,
            value: widget.plant.info.purchasedPrice,
            onChangeCurrency: (c) => widget.plant.info.currencySymbol = c,
            onChangeValue: (p) => widget.plant.info.purchasedPrice = p,
          ),
          EditableSimpleInfoEntry(
            title: AppLocalizations.of(context).seller,
            value: widget.plant.info.seller.toString(),
            onChanged: (s) => widget.plant.info.seller = s,
            onlyNumber: false,
          ),
          EditableSimpleInfoEntry(
            title: AppLocalizations.of(context).location,
            value: widget.plant.info.location.toString(),
            onChanged: (l) => widget.plant.info.location = l,
            onlyNumber: false,
          ),
          EditableFullWidthInfoEntry(
            value: widget.plant.info.note,
            title: AppLocalizations.of(context).note,
            onChanged: (n) => widget.plant.info.note = n,
          ),
          const SizedBox(
            height: 100,
          ),
        ]),
      ),
    );
  }
}
