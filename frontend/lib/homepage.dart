import 'package:flutter/material.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/multiple_dropdown.dart';

class HomePage extends StatelessWidget {
  final Environment env;
  const HomePage({super.key, required this.env});

  @override
  Widget build(BuildContext context) {
    return const Center(
      // child: Text("Home"),
      child: TextFieldWithDropDown(), //Text('Home'),
    );
  }
}
