import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/utils/icons.dart';

class EventTypeStep extends StepSection<CalendarViewModel> {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);

  EventTypeStep({super.key, required super.viewModel});

  @override
  State<EventTypeStep> createState() => _EventTypeStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  void confirm() {
    throw UnimplementedError();
  }

  @override
  String get title => throw UnimplementedError();

  @override
  String get value => throw UnimplementedError();
  
  @override
  void cancel() {
    // TODO: implement cancel
  }
}

class _EventTypeStepState extends State<EventTypeStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Which events you want to use as filter?",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 10),
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
                    children: List.generate(widget.viewModel.eventTypes.length,
                        (index) {
                      EventType eventType =
                          widget.viewModel.eventTypes.values.elementAt(index);
                      bool isEventTypeSelected = widget
                          .viewModel.filteredEventTypeIds
                          .contains(eventType.id);
                      return GestureDetector(
                        onTap: () {
                          if (isEventTypeSelected) {
                            widget.viewModel
                                .removeFilteredEventType(eventType.id);
                          } else {
                            widget.viewModel.addFilteredEventType(eventType.id);
                          }
                        },
                        child: Card.outlined(
                            shape: isEventTypeSelected
                                ? RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.all(
                                        Radius.circular(15)),
                                    side: isEventTypeSelected
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
