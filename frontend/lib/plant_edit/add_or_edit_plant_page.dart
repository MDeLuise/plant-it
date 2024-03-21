import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/plant_edit/add_or_edit_plant_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/plant_edit/header.dart';

class AddOrEditPlantPage extends StatefulWidget {
  final PlantDTO plantDTO;
  final Environment env;
  const AddOrEditPlantPage({
    super.key,
    required this.plantDTO,
    required this.env,
  });

  @override
  State<StatefulWidget> createState() => _AddOrEditPlantPage();
}

class _AddOrEditPlantPage extends State<AddOrEditPlantPage> {
  late PlantDTO _updated;

  void _updatePlant() async {
    final response = await widget.env.http
        .put("plant/${widget.plantDTO.id}", _updated.toMap());
    final responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      showSnackbar(context, SnackBarType.fail, responseBody["message"]);
      return;
    }
    showSnackbar(context, SnackBarType.success,
        AppLocalizations.of(context).plantUpdatedSuccessfully);
    Navigator.of(context).pop(PlantDTO.fromJson(responseBody));
  }

  void _createPlant() async {
    final response = await widget.env.http
        .post("plant/${widget.plantDTO.id}", _updated.toMap());
    final responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      showSnackbar(context, SnackBarType.fail, responseBody["message"]);
      return;
    }
    showSnackbar(context, SnackBarType.success,
        AppLocalizations.of(context).plantCreatedSuccessfully);
    Navigator.of(context).pop(responseBody);
  }

  @override
  void initState() {
    super.initState();
    _updated = widget.plantDTO;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_updated.id == null) {
              _createPlant();
            } else {
              _updatePlant();
            }
          },
          shape: const CircleBorder(),
          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
          child: Icon(widget.plantDTO.id == null
              ? Icons.add_outlined
              : Icons.save_outlined),
        ),
        body: NestedScrollViewPlus(
          overscrollBehavior: OverscrollBehavior.outer,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                pinned: true,
                stretch: true,
                expandedHeight: MediaQuery.of(context).size.height * .3,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: AddOrEditPlantImageHeader(
                    plant: widget.plantDTO,
                    env: widget.env,
                  ),
                ),
              ),
            ];
          },
          body: AddOrEditPlantBody(
            plant: _updated,
          ),
        ));
  }
}
