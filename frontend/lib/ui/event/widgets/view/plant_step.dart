import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';

class PlantStep extends StepSection<EventFormViewModel> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);
  final ValueNotifier<List<Plant>> _selectedPlants =
      ValueNotifier(List.unmodifiable([]));
  final ValueNotifier<List<Plant>> _ongoingSelection =
      ValueNotifier(List.unmodifiable([]));

  PlantStep({
    super.key,
    required super.viewModel,
  });

  @override
  State<PlantStep> createState() => _PlantStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  String get title => "Plants";

  @override
  String get value {
    List<Plant> plants = _ongoingSelection.value;
    if (plants.length < 3) {
      return _returnTruncatedPlantName(plants);
    }
    return "${plants.length} plants";
  }

  String _returnTruncatedPlantName(List<Plant> plants) {
    String result = plants.map((p) => p.name).join(", ");
    if (result.length > 50) {
      result = "${result.substring(0, 50)}...";
    }
    return result;
  }

  @override
  void confirm() {
    viewModel.setPlantList(_ongoingSelection.value);
    _selectedPlants.value = _ongoingSelection.value;
  }

  @override
  void cancel() {
    _ongoingSelection.value = _selectedPlants.value;
  }

  void addSelectedPlant(Plant eventType) {
    List<Plant> current = _ongoingSelection.value;
    _ongoingSelection.value = [...current, eventType];
    _isValidNotifier.value = true;
  }

  void removeSelectedPlant(Plant eventType) {
    List<Plant> newValue = _ongoingSelection.value.toList();
    newValue.removeWhere((et) => et.id == eventType.id);
    _ongoingSelection.value = newValue;
    _isValidNotifier.value = _ongoingSelection.value.isNotEmpty;
  }
}

class _PlantStepState extends State<PlantStep> {
  void togglePlant(Plant eventType) {
    bool isSelected =
        widget._ongoingSelection.value.any((et) => et.id == eventType.id);
    if (isSelected) {
      widget.removeSelectedPlant(eventType);
    } else {
      widget.addSelectedPlant(eventType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Which plants you want to add?",
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
                      Plant plant = widget.viewModel.plants[index];
                      bool isSelected = widget._ongoingSelection.value
                          .any((p) => p.id == plant.id);
                      return GestureDetector(
                        onTap: () => togglePlant(plant),
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
                                    widget.viewModel
                                        .getSpecies(plant.id)
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
