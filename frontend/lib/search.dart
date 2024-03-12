import 'package:flutter/material.dart';
import 'package:plant_it/environment.dart';

class SeachPage extends StatelessWidget {
  final Environment env;
  const SeachPage({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search'),
    );
  }
}
