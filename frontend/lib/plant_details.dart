import 'package:flutter/material.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';

class PlantDetails extends StatelessWidget {
  final Environment env;
  final PlantDTO plant;

  const PlantDetails({super.key, required this.env, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plant Details'),
      ),
      body: Center(
        child: Text('Plant: ${plant.id}'),
      ),
    );
  }
}
