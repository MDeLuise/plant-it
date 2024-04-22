import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:plant_it/info_entries.dart';

class AddSpeciesBody extends StatefulWidget {
  final SpeciesDTO species;

  const AddSpeciesBody({
    super.key,
    required this.species,
  });

  @override
  State<AddSpeciesBody> createState() => _AddSpeciesBodyState();
}

class _AddSpeciesBodyState extends State<AddSpeciesBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            InfoGroup(
              title: AppLocalizations.of(context).scientificClassification,
              padding: EdgeInsets.zero,
              children: [
                EditableSimpleInfoEntry(
                  title: AppLocalizations.of(context).family,
                  value: widget.species.family,
                  onChanged: (f) => widget.species.family = f,
                ),
                EditableSimpleInfoEntry(
                  title: AppLocalizations.of(context).genus,
                  value: widget.species.genus,
                  onChanged: (g) => widget.species.genus = g,
                  onlyNumber: false,
                ),
                EditableSimpleInfoEntry(
                  title: AppLocalizations.of(context).species,
                  value: widget.species.species,
                  onChanged: (s) => widget.species.species = s,
                ),
              ],
            ),
            InfoGroup(
              title: AppLocalizations.of(context).info,
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              children: [
                EditableFullWidthInfoEntry(
                  value: widget.species.synonyms == null
                      ? null
                      : widget.species.synonyms
                          ?.join(",")
                          .substring(1, widget.species.synonyms!.length - 1),
                  title: AppLocalizations.of(context).synonyms,
                  onChanged: (s) => widget.species.synonyms = s.split(","),
                ),
              ],
            ),
            InfoGroup(
              title: AppLocalizations.of(context).care,
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              children: [
                EditableSimpleInfoEntry(
                  title: AppLocalizations.of(context).light,
                  value: widget.species.care.light.toString(),
                  onChanged: (l) => widget.species.care.light = int.parse(l),
                  onlyNumber: true,
                  numberDecimal: false,
                ),
                EditableSimpleInfoEntry(
                  title: AppLocalizations.of(context).humidity,
                  value: widget.species.care.humidity.toString(),
                  onChanged: (h) => widget.species.care.humidity = int.parse(h),
                  onlyNumber: true,
                ),
                EditableSimpleInfoEntry(
                  title: AppLocalizations.of(context).minTemp,
                  value: widget.species.care.minTemp.toString(),
                  onChanged: (t) =>
                      widget.species.care.minTemp = double.parse(t),
                  onlyNumber: true,
                  numberSigned: true,
                  numberDecimal: true,
                ),
                EditableSimpleInfoEntry(
                  title: AppLocalizations.of(context).maxTemp,
                  value: widget.species.care.maxTemp.toString(),
                  onChanged: (t) =>
                      widget.species.care.maxTemp = double.parse(t),
                  onlyNumber: true,
                  numberSigned: true,
                  numberDecimal: true,
                ),
                EditableSimpleInfoEntry(
                  title: AppLocalizations.of(context).minPh,
                  value: widget.species.care.phMin.toString(),
                  onChanged: (p) => widget.species.care.phMin = double.parse(p),
                  onlyNumber: true,
                ),
                EditableSimpleInfoEntry(
                  title: AppLocalizations.of(context).maxPh,
                  value: widget.species.care.phMax.toString(),
                  onChanged: (p) => widget.species.care.phMax = double.parse(p),
                  onlyNumber: true,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
