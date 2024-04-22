import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/plant_edit/edit_plant_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/plant_edit/header.dart';
import 'package:toastification/toastification.dart';

class EditPlantPage extends StatefulWidget {
  final PlantDTO plantDTO;
  final Environment env;
  const EditPlantPage({
    super.key,
    required this.plantDTO,
    required this.env,
  });

  @override
  State<StatefulWidget> createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  late PlantDTO _updated;

  void _updatePlant() async {
    final response = await widget.env.http
        .put("plant/${widget.plantDTO.id}", _updated.toMap());
    final responseBody = json.decode(response.body);
    if (!mounted) return;
    if (response.statusCode != 200) {
      widget.env.logger.error(responseBody["message"]);
      throw AppException(responseBody["message"]);
    }
    widget.env.logger.info("Plant successfully updated");
    showSnackbar(context, ToastificationType.success,
        AppLocalizations.of(context).plantUpdatedSuccessfully);
    Navigator.of(context).pop(PlantDTO.fromJson(responseBody));
  }

  void _createPlant() async {
    final response = await widget.env.http
        .post("plant/${widget.plantDTO.id}", _updated.toMap());
    if (!mounted) return;
    final responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      widget.env.logger.error(responseBody["message"]);
      throw AppException(responseBody["message"]);
    }
    widget.env.logger.info("Plant successfully created");
    showSnackbar(context, ToastificationType.success,
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
          child: Icon(
            widget.plantDTO.id == null
                ? Icons.add_outlined
                : Icons.save_outlined,
          ),
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
                  background: EditPlantImageHeader(
                    plant: widget.plantDTO,
                    env: widget.env,
                  ),
                ),
              ),
            ];
          },
          body: EditPlantBody(
            plant: _updated,
          ),
        ));
  }
}
