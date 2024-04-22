import 'package:flutter/material.dart';
import 'package:plant_it/dto/species_dto.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/info_entries.dart';

class SpeciesDetailsTab extends StatefulWidget {
  final SpeciesDTO species;
  final bool isLoading;
  const SpeciesDetailsTab({
    super.key,
    required this.species,
    required this.isLoading,
  });

  @override
  State<StatefulWidget> createState() => _SpeciesDetailsTabState();
}

class _SpeciesDetailsTabState extends State<SpeciesDetailsTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          InfoGroup(
            title: AppLocalizations.of(context).scientificClassification,
            children: widget.isLoading
                ? generateSkeleton(3, widget.isLoading)
                : [
                    SimpleInfoEntry(
                        title: AppLocalizations.of(context).family,
                        value: widget.species.family),
                    SimpleInfoEntry(
                        title: AppLocalizations.of(context).genus,
                        value: widget.species.genus),
                    SimpleInfoEntry(
                        title: AppLocalizations.of(context).species,
                        value: widget.species.species)
                  ],
          ),
          InfoGroup(
            title: AppLocalizations.of(context).info,
            children: widget.isLoading
                ? generateSkeleton(1, widget.isLoading)
                : [
                    FullWidthInfoEntry(
                      title: AppLocalizations.of(context).synonyms,
                      value: widget.species.synonyms
                          ?.join(",")
                          .replaceAll("[", "")
                          .replaceAll("]", ""),
                    )
                  ],
          ),
          InfoGroup(
            title: AppLocalizations.of(context).care,
            children: widget.isLoading
                ? generateSkeleton(6, widget.isLoading)
                : [
                    SimpleInfoEntry(
                      title: AppLocalizations.of(context).light,
                      value: widget.species.care.light == null
                          ? null
                          : AppLocalizations.of(context)
                              .nOutOf(widget.species.care.light ?? 0, 10),
                    ),
                    SimpleInfoEntry(
                      title: AppLocalizations.of(context).humidity,
                      value: widget.species.care.humidity == null
                          ? null
                          : AppLocalizations.of(context)
                              .nOutOf(widget.species.care.humidity ?? 0, 10),
                    ),
                    SimpleInfoEntry(
                        title: AppLocalizations.of(context).maxTemp,
                        value: widget.species.care.maxTemp == null
                            ? null
                            : AppLocalizations.of(context)
                                .temp(widget.species.care.maxTemp ?? 0)),
                    SimpleInfoEntry(
                        title: AppLocalizations.of(context).minTemp,
                        value: widget.species.care.minTemp == null
                            ? null
                            : AppLocalizations.of(context)
                                .temp(widget.species.care.minTemp ?? 0)),
                    SimpleInfoEntry(
                        title: AppLocalizations.of(context).maxPh,
                        value: widget.species.care.phMax.toString()),
                    SimpleInfoEntry(
                        title: AppLocalizations.of(context).minPh,
                        value: widget.species.care.phMin.toString()),
                  ],
          )
        ],
      ),
    );
  }
}
