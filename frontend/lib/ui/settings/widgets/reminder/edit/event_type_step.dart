import 'package:flutter/material.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/core/ui/step_section.dart';
import 'package:plant_it/ui/settings/view_models/reminder/edit_reminder_viewmodel.dart';
import 'package:plant_it/utils/icons.dart';

class EventTypeStep extends StepSection<EditReminderViewModel> {
  final L appLocalizations;
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);
  late final ValueNotifier<EventType> _selectedEventTypes =
      ValueNotifier(viewModel.eventTypes[viewModel.type]!);
  late final ValueNotifier<EventType> _ongoingSelection =
      ValueNotifier(viewModel.eventTypes[viewModel.type]!);

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
  String get title => "Event Type";

  @override
  String get value => _ongoingSelection.value.name;

  @override
  void confirm() {
    viewModel.setType(_ongoingSelection.value);
    _selectedEventTypes.value = _ongoingSelection.value;
  }

  @override
  void cancel() {
    _ongoingSelection.value = _selectedEventTypes.value;
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
          L.of(context).whichEventsYouWantToSet,
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
                        widget.viewModel.eventTypes.entries.length, (index) {
                      EventType eventType = widget.viewModel.eventTypes.entries
                          .elementAt(index)
                          .value;
                      bool isSelected =
                          widget._ongoingSelection.value == eventType;
                      return GestureDetector(
                        onTap: () {
                          widget._ongoingSelection.value = eventType;
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
