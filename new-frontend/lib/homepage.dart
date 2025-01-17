import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final Environment env;

  const Homepage(this.env, {super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Text("Homepage"),
    );
  }
}
