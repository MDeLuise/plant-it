import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart' as db;
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/search/view_models/search_viewmodel.dart';

class SpeciesCard extends StatelessWidget {
  final SearchViewModel viewModel;
  final SpeciesSearcherPartialResult speciesSearcherResult;

  const SpeciesCard({
    super.key,
    required this.speciesSearcherResult,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewModel.getImageBase64(speciesSearcherResult),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        db.SpeciesDataSource source =
            speciesSearcherResult.speciesCompanion.dataSource.value;

        return Padding(
          padding: const EdgeInsets.all(12),
          child: Card.filled(
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.all(Radius.circular(15)),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                      height: MediaQuery.of(context).size.height * .17,
                      child: Image(
                        fit: BoxFit.cover,
                        image: snapshot.data!.getOrThrow().isEmpty
                            ? const AssetImage(
                                "assets/images/generic-plant.jpg")
                            : MemoryImage(
                                    base64Decode(snapshot.data!.getOrThrow()))
                                as ImageProvider,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Chip(
                        labelPadding: EdgeInsets.all(0),
                        label: Text(
                          source == db.SpeciesDataSource.custom
                              ? L.of(context).custom
                              : L.of(context).floraCodex,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        child: Text(
                          speciesSearcherResult
                              .speciesCompanion.scientificName.value,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        child: Text(
                          speciesSearcherResult.speciesCompanion.species.value,
                          overflow: TextOverflow.visible,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
