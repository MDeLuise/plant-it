import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/routing/routes.dart';

class EmptySearch extends StatelessWidget {
  final String searchedSpecies;

  const EmptySearch({
    super.key,
    required this.searchedSpecies,
  });

  @override
  Widget build(BuildContext context) {
    L appLocalizations = L.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
            child: Container(
              height: 80,
              width: 80,
              color: Theme.of(context).colorScheme.primary,
              child: Icon(
                LucideIcons.circle_off,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            appLocalizations.noSpeciesFound,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            appLocalizations.searchAndAddSpeciesInstructions,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.push(
                  Routes.species,
                  extra: searchedSpecies,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  elevation: 0,
                ),
                child: Text(appLocalizations.createSpecies),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                onPressed: () => context.push(Routes.settingsDataSources),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  elevation: 0,
                ),
                child: Text(appLocalizations.connectToAService),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
