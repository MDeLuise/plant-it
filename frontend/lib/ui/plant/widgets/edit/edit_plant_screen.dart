import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';
import 'package:plant_it/ui/plant/view_models/edit_plant_viewmodel.dart';
import 'package:plant_it/ui/plant/widgets/edit/location_step.dart';
import 'package:plant_it/ui/plant/widgets/edit/name_step.dart';
import 'package:plant_it/ui/plant/widgets/edit/price_step.dart';
import 'package:plant_it/ui/plant/widgets/edit/seller_step.dart';
import 'package:plant_it/ui/plant/widgets/edit/start_date_step.dart';

class EditPlantScreen extends StatefulWidget {
  final EditPlantViewModel viewModel;

  const EditPlantScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text('Edit Plant'),
      ),
      body: AppStepper<EditPlantViewModel>(
          viewModel: widget.viewModel,
          mainCommand: widget.viewModel.load,
          actionText: "Update",
          actionCommand: widget.viewModel.update,
          successText: "Plant updated",
          summary: true,
          stepsInFocus: 0,
          steps: [
            NameStep(viewModel: widget.viewModel),
            StartDateStep(viewModel: widget.viewModel),
            PriceStep(viewModel: widget.viewModel),
            SellerStep(viewModel: widget.viewModel),
            LocationStep(viewModel: widget.viewModel),
          ]),
    );
  }
}
