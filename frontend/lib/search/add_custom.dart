import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/species_add/add_species_page.dart';

class AddCustomCard extends StatelessWidget {
  final String? species;
  final Environment env;

  const AddCustomCard({
    super.key,
    this.species,
    required this.env,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => goToPageSlidingUp(
        context,
        AddSpeciesPage(
          name: species,
          env: env,
        ),
      ),
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .4,
              minHeight: MediaQuery.of(context).size.height * .4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Image.asset(
                        "assets/images/add-custom.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Text(
                        AppLocalizations.of(context).custom,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
