import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';
import 'package:plant_it/ui/plant/view_models/add_plant_viewmodel.dart';
import 'package:plant_it/ui/plant/widgets/create/location_step.dart';
import 'package:plant_it/ui/plant/widgets/create/name_step.dart';
import 'package:plant_it/ui/plant/widgets/create/price_step.dart';
import 'package:plant_it/ui/plant/widgets/create/seller_step.dart';
import 'package:plant_it/ui/plant/widgets/create/start_date_step.dart';

class AddPlantScreen extends StatefulWidget {
  final AddPlantViewModel viewModel;

  const AddPlantScreen({
    super.key,
    required this.viewModel,
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
        title: const Text('Add Plant'),
      ),
      body: AppStepper<AddPlantViewModel>(
          viewModel: widget.viewModel,
          mainCommand: widget.viewModel.load,
          actionText: "Add",
          actionCommand: widget.viewModel.insert,
          successText: "Plant added",
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
