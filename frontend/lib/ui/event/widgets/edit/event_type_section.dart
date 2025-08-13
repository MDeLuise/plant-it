import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/event/view_models/edit_event_viewmodel.dart';
import 'package:plant_it/utils/icons.dart';

class EventTypeSection extends StepSection<EditEventFormViewModel> {
  final ValueNotifier<bool> _valid = ValueNotifier<bool>(true);
  late final ValueNotifier<EventType?> _selectedEventType =
      ValueNotifier<EventType?>(viewModel.eventType);
  late final ValueNotifier<EventType?> _ongoingSelection = ValueNotifier(viewModel.eventType);

  EventTypeSection({
    super.key,
    required super.viewModel,
  });

  @override
  State<EventTypeSection> createState() => _EventTypeSectionState();

  @override
  ValueNotifier<bool> get isValidNotifier => _valid;

  @override
  String get title => "Event Type";

  @override
  String get value => _ongoingSelection.value!.name;

  @override
  void confirm() {
    viewModel.setEventType(_ongoingSelection.value!);
    _selectedEventType.value = _ongoingSelection.value;
  }

  @override
  void cancel() {
    _ongoingSelection.value = _selectedEventType.value;
  }
}

class _EventTypeSectionState extends State<EventTypeSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select the event type",
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
                        widget.viewModel.eventTypes.values.length, (index) {
                      EventType eventType =
                          widget.viewModel.eventTypes.values.elementAt(index);
                      bool isSelected =
                          widget._ongoingSelection.value!.id == eventType.id;
                      return GestureDetector(
                        onTap: () => setState(
                            () => widget._ongoingSelection.value = eventType),
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
