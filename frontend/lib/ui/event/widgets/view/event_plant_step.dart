import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/ui/core/ui/stepper/stepper_step.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';

class EventPlantStep extends StepperStep {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);
  final EventFormViewModel viewModel;

  EventPlantStep({super.key, required this.viewModel,});

  @override
  State<EventPlantStep> createState() => _EventPlantStepState();
  
  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;
}

class _EventPlantStepState extends State<EventPlantStep> {
  
  void changeValidValueIfNeeded() {
    widget._isValidNotifier.value = widget.viewModel.selectedPlants.isNotEmpty;
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
            animation: widget.viewModel,
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
                      return GestureDetector(
                        onTap: () {
                          if (widget.viewModel.isPlantSelected(plant)) {
                            widget.viewModel.removePlant(plant);
                            changeValidValueIfNeeded();
                          } else {
                            widget.viewModel.addPlant(plant);
                            changeValidValueIfNeeded();
                          }
                        },
                        child: Card.outlined(
                            shape: widget.viewModel.isPlantSelected(plant)
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.all(
                                        Radius.circular(15)),
                                    side:
                                        widget.viewModel.isPlantSelected(plant)
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
