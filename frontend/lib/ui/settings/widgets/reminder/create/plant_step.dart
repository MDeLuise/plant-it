import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/settings/view_models/reminder/add_reminder_viewmodel.dart';

class PlantStep extends StepSection<AddReminderViewModel> {
  final AppLocalizations appLocalizations;
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);
  final ValueNotifier<Plant?> _selectedPlants = ValueNotifier(null);
  final ValueNotifier<Plant?> _ongoingSelection = ValueNotifier(null);

  PlantStep({
    super.key,
    required super.viewModel,
    required this.appLocalizations,
  });

  @override
  State<PlantStep> createState() => _PlantStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  String get title => "Plants";

  @override
  String get value => _ongoingSelection.value?.name ?? "";

  @override
  void confirm() {
    viewModel.setPlant(_ongoingSelection.value!);
    _selectedPlants.value = _ongoingSelection.value;
  }

  @override
  void cancel() {
    _ongoingSelection.value = _selectedPlants.value;
  }
}

class _PlantStepState extends State<PlantStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.whichPlantsYouWantToSet,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
            animation: widget._ongoingSelection,
            builder: (context, _) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .7,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3.7 / 2,
                    children:
                        List.generate(widget.viewModel.plants.length, (index) {
                      Plant plant = widget.viewModel.plants.entries
                          .elementAt(index)
                          .value;
                      bool isSelected = widget._ongoingSelection.value == plant;
                      return GestureDetector(
                        onTap: () {
                          widget._ongoingSelection.value = plant;
                          widget._isValidNotifier.value = true;
                        },
                        child: Card.outlined(
                            shape: isSelected
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.all(
                                        Radius.circular(15)),
                                    side: isSelected
                                        ? BorderSide(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 2)
                                        : BorderSide.none,
                                  )
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(plant.name),
                                  const SizedBox(height: 8),
                                  Text(
                                    widget.viewModel.species[plant.species]!
                                        .scientificName,
                                    style:
                                        TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            )),
                      );
                    }),
                  ),
                ),
              );
            })
      ],
    );
  }
}
