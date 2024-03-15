import 'package:flutter/material.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/homepage_header.dart';
import 'package:plant_it/plant_list.dart';

class HomePage extends StatelessWidget {
  final Environment env;
  const HomePage({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomePageHeader(),
        PlantList(
          env: env,
        ),
      ],
    );
  }
}
