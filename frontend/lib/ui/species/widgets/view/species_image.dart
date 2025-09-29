import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:plant_it/ui/species/view_models/view_species_viewmodel.dart';

class SpeciesImage extends StatelessWidget {
  final ViewSpeciesViewModel viewModel;

  const SpeciesImage({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: viewModel.base64image == null
            ? const DecorationImage(
                image: AssetImage("assets/images/generic-plant.jpg"),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: MemoryImage(base64Decode(viewModel.base64image!)),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
