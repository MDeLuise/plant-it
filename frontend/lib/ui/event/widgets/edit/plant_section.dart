import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/event/view_models/edit_event_viewmodel.dart';

class PlantSection extends StepSection<EditEventFormViewModel> {
  final ValueNotifier<bool> _valid = ValueNotifier<bool>(true);
  late final ValueNotifier<Plant?> _selectedPlant =
      ValueNotifier<Plant?>(viewModel.plant);
  late final ValueNotifier<Plant?> _ongoingSelection =
      ValueNotifier<Plant?>(viewModel.plant);

  PlantSection({
    super.key,
    required super.viewModel,
    required super.appLocalizations,
  });

  @override
  State<PlantSection> createState() => _PlantSectionState();

  @override
  ValueNotifier<bool> get isValidNotifier => _valid;

  @override
  String get title => appLocalizations.plant;

  @override
  String get value => _ongoingSelection.value!.name;

  @override
  void confirm() {
    viewModel.setPlant(_ongoingSelection.value!);
  }

  @override
  void cancel() {
    _ongoingSelection.value = _selectedPlant.value;
  }
}

class _PlantSectionState extends State<PlantSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          L.of(context).selectThePlant,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 10),
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
                    children: List.generate(
                        widget.viewModel.plants.values.length, (index) {
                      Plant plant =
                          widget.viewModel.plants.values.elementAt(index);
                      bool isSelected =
                          widget._ongoingSelection.value!.id == plant.id;
                      return GestureDetector(
                        onTap: () => setState(
                            () => widget._ongoingSelection.value = plant),
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
