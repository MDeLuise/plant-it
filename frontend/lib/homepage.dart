import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class HomePage extends StatefulWidget {
  final Environment env;

  const HomePage({super.key, required this.env});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        ElevatedButton(
            onPressed: () {
              showSnackbar(context, ContentType.failure, "foo");
            },
            child: const Text("test")),
        ElevatedButton(
            onPressed: () {
              showSnackbar(context, ContentType.help, "foo");
            },
            child: const Text("test")),
        ElevatedButton(
            onPressed: () {
              showSnackbar(context, ContentType.success, "foo");
            },
            child: const Text("test")),
        ElevatedButton(
            onPressed: () {
              showSnackbar(context, ContentType.warning, "foo");
            },
            child: const Text("test")),
      ],
    )));
  }
}
