import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/l10n/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';
import 'package:plant_it/utils/icons.dart';

class EventTypeStep extends StepSection<CreateEventFormViewModel> {
  final AppLocalizations appLocalizations;
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);
  final ValueNotifier<List<EventType>> _selectedEventTypes =
      ValueNotifier(List.unmodifiable([]));
  final ValueNotifier<List<EventType>> _ongoingSelection =
      ValueNotifier(List.unmodifiable([]));

  EventTypeStep({
    super.key,
    required super.viewModel,
    required this.appLocalizations,
  });

  @override
  State<EventTypeStep> createState() => _EventTypeStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;

  @override
  String get title => appLocalizations.eventTypes;

  @override
  String get value {
    List<EventType> eventTypes = _ongoingSelection.value;
    if (eventTypes.length < 3) {
      return _returnTruncatedEventTypeName(eventTypes);
    }
    return appLocalizations.nEventTypes(eventTypes.length);
  }

  String _returnTruncatedEventTypeName(List<EventType> eventTypes) {
    String result = eventTypes.map((p) => p.name).join(", ");
    if (result.length > 50) {
      result = "${result.substring(0, 50)}...";
    }
    return result;
  }

  @override
  void confirm() {
    viewModel.setEventTypeList(_ongoingSelection.value);
    _selectedEventTypes.value = _ongoingSelection.value;
  }

  @override
  void cancel() {
    _ongoingSelection.value = _selectedEventTypes.value;
  }

  void addSelectedEventType(EventType eventType) {
    List<EventType> current = _ongoingSelection.value;
    _ongoingSelection.value = [...current, eventType];
    _isValidNotifier.value = true;
  }

  void removeSelectedEventType(EventType eventType) {
    List<EventType> newValue = _ongoingSelection.value.toList();
    newValue.removeWhere((et) => et.id == eventType.id);
    _ongoingSelection.value = newValue;
    _isValidNotifier.value = _ongoingSelection.value.isNotEmpty;
  }
}

class _EventTypeStepState extends State<EventTypeStep> {
  void toggleEventType(EventType eventType) {
    bool isSelected =
        widget._ongoingSelection.value.any((et) => et.id == eventType.id);
    if (isSelected) {
      widget.removeSelectedEventType(eventType);
    } else {
      widget.addSelectedEventType(eventType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.whichEventsYouWantToAdd,
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
                    children: List.generate(widget.viewModel.eventTypes.length,
                        (index) {
                      EventType eventType = widget.viewModel.eventTypes[index];
                      bool isSelected = widget._ongoingSelection.value
                          .any((et) => et.id == eventType.id);
                      return GestureDetector(
                        onTap: () => toggleEventType(eventType),
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
