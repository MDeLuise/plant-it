import 'dart:async';

import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/summary.dart';
import 'package:plant_it/ui/plant/view_models/add_plant_viewmodel.dart';
import 'package:plant_it/ui/plant/widgets/create/location_step.dart';
import 'package:plant_it/ui/plant/widgets/create/name_step.dart';
import 'package:plant_it/ui/plant/widgets/create/price_step.dart';
import 'package:plant_it/ui/plant/widgets/create/seller_step.dart';
import 'package:plant_it/ui/plant/widgets/create/start_date_step.dart';
import 'package:plant_it/utils/stream_code.dart';

class AddPlantScreen extends StatefulWidget {
  final AddPlantViewModel viewModel;
  final StreamController<StreamCode> streamController;

  const AddPlantScreen({
    super.key,
    required this.viewModel,
    required this.streamController,
  });

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: Text(AppLocalizations.of(context)!.addPlant),
      ),
      body: Summary<AddPlantViewModel>(
          viewModel: widget.viewModel,
          mainCommand: widget.viewModel.load,
          actionText: AppLocalizations.of(context)!.add,
          actionCommand: Command.createAsyncNoParam(() async {
            Command<void, int> command = widget.viewModel.insert;
            await command.executeWithFuture();
            if (command.results.value.hasError) {
              throw Exception(command.results.value.error);
            }
            widget.streamController.add(StreamCode.insertPlant);
          }, initialValue: null),
          successText: AppLocalizations.of(context)!.plantAdded,
          isPrimary: false,
          sections: [
            NameStep(viewModel: widget.viewModel),
            StartDateStep(viewModel: widget.viewModel),
            PriceStep(viewModel: widget.viewModel),
            SellerStep(viewModel: widget.viewModel),
            LocationStep(viewModel: widget.viewModel),
          ]),
    );
  }
}
