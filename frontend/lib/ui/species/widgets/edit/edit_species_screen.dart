import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/ui/core/ui/summary.dart';
import 'package:plant_it/ui/species/view_models/edit_species_viewmodel.dart';
import 'package:plant_it/ui/species/widgets/edit/avatar_step.dart';
import 'package:plant_it/ui/species/widgets/edit/care_step.dart';
import 'package:plant_it/ui/species/widgets/edit/classification_step.dart';

class EditSpeciesScreen extends StatefulWidget {
  final EditSpeciesViewModel viewModel;
  final String? searchedTerm;

  const EditSpeciesScreen({
    super.key,
    required this.viewModel,
    this.searchedTerm,
  });

  @override
  State<EditSpeciesScreen> createState() => _EditSpeciesScreenState();
}

class _EditSpeciesScreenState extends State<EditSpeciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text('Edit Species'),
      ),
      body: Summary<EditSpeciesViewModel>(
          viewModel: widget.viewModel,
          mainCommand: widget.viewModel.load,
          actionText: "Update",
          actionCommand: widget.viewModel.update,
          successText: "Species updated",
          isPrimary: false,
          sections: [
            ClassificationStep(viewModel: widget.viewModel),
            CareStep(viewModel: widget.viewModel),
            AvatarStep(viewModel: widget.viewModel),
          ]),
    );
  }
}
