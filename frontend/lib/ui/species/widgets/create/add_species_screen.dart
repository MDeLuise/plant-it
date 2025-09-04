import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/stepper.dart';
import 'package:plant_it/ui/species/view_models/add_species_viewmodel.dart';
import 'package:plant_it/ui/species/widgets/create/avatar_step.dart';
import 'package:plant_it/ui/species/widgets/create/care_step.dart';
import 'package:plant_it/ui/species/widgets/create/classification_step.dart';

class AddSpeciesScreen extends StatefulWidget {
  final AddSpeciesViewModel viewModel;
  final String? searchedTerm;

  const AddSpeciesScreen({
    super.key,
    required this.viewModel,
    this.searchedTerm,
  });

  @override
  State<AddSpeciesScreen> createState() => _AddSpeciesScreenState();
}

class _AddSpeciesScreenState extends State<AddSpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: Text(L.of(context).createSpecies),
      ),
      body: AppStepper<AddSpeciesViewModel>(
          viewModel: widget.viewModel,
          mainCommand: Command.createAsyncNoParamNoResult(() => Future.value()),
          actionText: L.of(context).create,
          actionCommand: widget.viewModel.insert,
          successText: L.of(context).speciesCreated,
          summary: true,
          stepsInFocus: 2,
          steps: [
            ClassificationStep(
              viewModel: widget.viewModel,
              initialSpecies: widget.searchedTerm,
            ),
            CareStep(viewModel: widget.viewModel),
            AvatarStep(viewModel: widget.viewModel),
          ]),
    );
  }
}
