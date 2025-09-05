import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';
import 'package:plant_it/ui/plant/view_models/edit_plant_viewmodel.dart';
import 'package:plant_it/ui/plant/widgets/edit/location_step.dart';
import 'package:plant_it/ui/plant/widgets/edit/name_step.dart';
import 'package:plant_it/ui/plant/widgets/edit/price_step.dart';
import 'package:plant_it/ui/plant/widgets/edit/seller_step.dart';
import 'package:plant_it/ui/plant/widgets/edit/start_date_step.dart';
import 'package:plant_it/utils/stream_code.dart';

class EditPlantScreen extends StatefulWidget {
  final EditPlantViewModel viewModel;
  final StreamController<StreamCode> streamController;

  const EditPlantScreen({
    super.key,
    required this.viewModel,
    required this.streamController
  });

  @override
  State<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  @override
  Widget build(BuildContext context) {
    L appLocalizations = L.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: Text(appLocalizations.editPlant),
      ),
      body: AppStepper<EditPlantViewModel>(
          viewModel: widget.viewModel,
          mainCommand: widget.viewModel.load,
          actionText: appLocalizations.update,
          actionCommand: Command.createAsyncNoParam(() async {
            Command<void, bool> command = widget.viewModel.update;
            await command.executeWithFuture();
            if (command.results.value.hasError) {
              throw Exception(command.results.value.error);
            }
            widget.streamController.add(StreamCode.editPlant);
          }, initialValue: null),
          successText: appLocalizations.plantUpdated,
          summary: true,
          stepsInFocus: 0,
          steps: [
            NameStep(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
            StartDateStep(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
            PriceStep(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
            SellerStep(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
            LocationStep(
              viewModel: widget.viewModel,
              appLocalizations: appLocalizations,
            ),
          ]),
    );
  }
}
