import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final Environment env;

  const SearchPage(this.env, {super.key});

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Text("Search"),
    );
  }
}
