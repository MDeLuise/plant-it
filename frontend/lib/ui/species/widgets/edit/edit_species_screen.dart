import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
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
    L appLocalizations = L.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: context.pop,
        ),
        title: Text(L.of(context).editSpecies),
      ),
      body: ValueListenableBuilder<CommandResult<void, void>>(
          valueListenable: widget.viewModel.load.results,
          builder: (context, value, child) {
            if (value.isExecuting) {
              return Center(child: CircularProgressIndicator());
            }
            return Summary<EditSpeciesViewModel>(
                viewModel: widget.viewModel,
                mainCommand: widget.viewModel.load,
                actionText: L.of(context).update,
                actionCommand: widget.viewModel.update,
                successText: L.of(context).speciesUpdated,
                isPrimary: false,
                sections: [
                  ClassificationStep(
                    viewModel: widget.viewModel,
                    appLocalizations: appLocalizations,
                  ),
                  CareStep(
                    viewModel: widget.viewModel,
                    appLocalizations: appLocalizations,
                  ),
                  AvatarStep(
                    viewModel: widget.viewModel,
                    appLocalizations: appLocalizations,
                  ),
                ]);
          }),
    );
  }
}
