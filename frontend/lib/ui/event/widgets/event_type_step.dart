import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/ui/core/ui/stepper/stepper_step.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';
import 'package:plant_it/utils/icons.dart';

class EventTypeStep extends StepperStep {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);
  final EventFormViewModel viewModel;

  EventTypeStep({super.key, required this.viewModel});

  @override
  State<EventTypeStep> createState() => _EventTypeStepState();
  
  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;
}

class _EventTypeStepState extends State<EventTypeStep> {
  void changeValidValueIfNeeded() {
    widget._isValidNotifier.value = widget.viewModel.selectedEventTypes.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Which events you want to add?",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 10),
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
                    children: List.generate(widget.viewModel.eventTypes.length,
                        (index) {
                      EventType eventType = widget.viewModel.eventTypes[index];
                      return GestureDetector(
                        onTap: () {
                          if (widget.viewModel.isEventTypeSelected(eventType)) {
                            widget.viewModel.removeEventType(eventType);
                            changeValidValueIfNeeded();
                          } else {
                            widget.viewModel.addEventType(eventType);
                            changeValidValueIfNeeded();
                          }
                        },
                        child: Card.outlined(
                            shape:
                                widget.viewModel.isEventTypeSelected(eventType)
                                    ? RoundedRectangleBorder(
                                        borderRadius: BorderRadiusGeometry.all(
                                            Radius.circular(15)),
                                        side: widget.viewModel
                                                .isEventTypeSelected(eventType)
                                            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
                                            : BorderSide.none,
                                      )
                                    : null,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(appIcons[eventType.icon]),
                                  const SizedBox(height: 8),
                                  Text(eventType.name),
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
