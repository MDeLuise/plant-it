import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/info_entries.dart';

class AddPlantBody extends StatefulWidget {
  final PlantDTO toCreate;

  const AddPlantBody({
    super.key,
    required this.toCreate,
  });

  @override
  State<StatefulWidget> createState() => _AddPlantBodyState();
}

class _AddPlantBodyState extends State<AddPlantBody> {
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
            value: widget.toCreate.info.personalName,
            onChanged: (name) => widget.toCreate.info.personalName = name,
            onlyNumber: false,
          ),
          EditableDateInfoEntry(
            title: AppLocalizations.of(context).birthday,
            emptyHint: AppLocalizations.of(context).noBirthday,
            value: DateTime.now(),
            onChange: (d) {
              if (d != null) {
                widget.toCreate.info.startDate = d.toIso8601String();
              } else {
                widget.toCreate.info.startDate = null;
              }
            },
          ),
          EditableCurrencyInfoEntry(
            currency: widget.toCreate.info.currencySymbol,
            title: AppLocalizations.of(context).purchasedPrice,
            value: widget.toCreate.info.purchasedPrice,
            onChangeCurrency: (c) => widget.toCreate.info.currencySymbol = c,
            onChangeValue: (p) => widget.toCreate.info.purchasedPrice = p,
          ),
          EditableSimpleInfoEntry(
            title: AppLocalizations.of(context).seller,
            value: widget.toCreate.info.seller.toString(),
            onChanged: (s) => widget.toCreate.info.seller = s,
            onlyNumber: false,
          ),
          EditableSimpleInfoEntry(
            title: AppLocalizations.of(context).location,
            value: widget.toCreate.info.location.toString(),
            onChanged: (l) => widget.toCreate.info.location = l,
            onlyNumber: false,
          ),
          EditableFullWidthInfoEntry(
            value: widget.toCreate.info.note,
            title: AppLocalizations.of(context).note,
            onChanged: (n) => widget.toCreate.info.note = n,
          ),
          const SizedBox(
            height: 100,
          ),
        ]),
      ),
    );
  }
}
