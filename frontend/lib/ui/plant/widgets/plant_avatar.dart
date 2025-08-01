import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/ui/plant/view_models/plant_view_model.dart';

class PlantAvatar extends StatelessWidget {
  final PlantViewModel viewModel;

  const PlantAvatar({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: viewModel.base64Avatar == null
            ? const DecorationImage(
                image: AssetImage("assets/images/generic-plant.jpg"),
                fit: BoxFit.cover,
              )
            : DecorationImage(
                image: MemoryImage(base64Decode(viewModel.base64Avatar!)),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
