import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/routing/routes.dart';

class HomeScreenEmptyData extends StatelessWidget {
  const HomeScreenEmptyData({super.key});

  Future<void> _showInstrutions(BuildContext context) {
    L appLocalizations = L.of(context);

    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    appLocalizations.howToAddPlants,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  SizedBox(height: 10),
                  Text(appLocalizations.addPlantInstruction),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                      context.push(Routes.home, extra: 2);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      elevation: 0,
                    ),
                    child: Text(appLocalizations.searchASpecies),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    L appLocalizations = L.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(20)),
            child: Container(
              height: 80,
              width: 80,
              color: Theme.of(context).colorScheme.primary,
              child: Icon(
                LucideIcons.leaf,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            appLocalizations.noPlantsFound,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            appLocalizations.yourPlantWillAppearHere,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showInstrutions(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              elevation: 0,
            ),
            child: Text(appLocalizations.howToAddPlants),
          ),
        ],
      ),
    );
  }
}
