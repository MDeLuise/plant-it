import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/back_button.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/plant_edit/edit_plant_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/plant_edit/header.dart';
import 'package:plant_it/toast/toast_manager.dart';

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
    final responseBody = json.decode(utf8.decode(response.bodyBytes));
    if (!mounted) return;
    if (response.statusCode != 200) {
      widget.env.logger.error(responseBody["message"]);
      throw AppException(responseBody["message"]);
    }
    widget.env.logger.info("Plant successfully updated");
    widget.env.toastManager.showToast(context, ToastNotificationType.success,
        AppLocalizations.of(context).plantUpdatedSuccessfully);
    Navigator.of(context).pop(PlantDTO.fromJson(responseBody));
  }

  void _createPlant() async {
    final response = await widget.env.http
        .post("plant/${widget.plantDTO.id}", _updated.toMap());
    if (!mounted) return;
    final responseBody = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode != 200) {
      widget.env.logger.error(responseBody["message"]);
      throw AppException(responseBody["message"]);
    }
    widget.env.logger.info("Plant successfully created");
    widget.env.toastManager.showToast(context, ToastNotificationType.success,
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
          widget.plantDTO.id == null ? Icons.add_outlined : Icons.save_outlined,
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * .3,
                    maxHeight: MediaQuery.of(context).size.height * .3,
                  ),
                  child: EditPlantImageHeader(
                    plant: _updated,
                    env: widget.env,
                  ),
                ),
                EditPlantBody(plant: _updated),
              ],
            ),
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: AppBackButton(),
          ),
        ],
      ),
    );
  }
}
