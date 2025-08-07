import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/core/ui/stepper/stepper_step.dart';

class PlantStep extends StepperStep {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  final CalendarViewModel viewModel;

  PlantStep({super.key, required this.viewModel,});

  @override
  State<PlantStep> createState() => _PlantStepState();
  
  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;
}

class _PlantStepState extends State<PlantStep> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Which plants you want to use as filter?",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
            animation: widget.viewModel,
            builder: (context, _) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .6,
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 3.7 / 2,
                    children:
                        List.generate(widget.viewModel.plants.keys.length, (index) {
                      Plant plant = widget.viewModel.plants.values.elementAt(index);
                      bool isPlantSelected = widget.viewModel.filteredPlantIds.contains(plant.id);
                      return GestureDetector(
                        onTap: () {
                          if (isPlantSelected) {
                            widget.viewModel.removeFilteredPlant(plant.id);
                          } else {
                            widget.viewModel.addFilteredPlant(plant.id);
                          }
                        },
                        child: Card.outlined(
                            shape: isPlantSelected
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.all(
                                        Radius.circular(15)),
                                    side:
                                        isPlantSelected
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
                                        .species[plant.species]!
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
