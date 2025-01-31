import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/loading_button.dart';

class ReminderFilter extends StatefulWidget {
  final Environment env;
  final List<EventType> selectedEventTypes;
  final List<Plant> selectedPlants;
  final List<EventType> eventTypes;
  final List<Plant> plants;
  final Function(List<EventType> eventTypes, List<Plant> plants) callback;

  const ReminderFilter(this.env, this.eventTypes, this.plants,
      this.selectedEventTypes, this.selectedPlants, this.callback,
      {super.key});

  @override
  State<ReminderFilter> createState() => _ReminderFilterState();
}

class _ReminderFilterState extends State<ReminderFilter> {
  final _formKey = GlobalKey<FormState>();
  final eventTypeController = MultiSelectController<EventType>();
  final plantController = MultiSelectController<Plant>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventTypeController
          .selectWhere((t) => widget.selectedEventTypes.contains(t.value));
      plantController
          .selectWhere((p) => widget.selectedPlants.contains(p.value));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .7,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Filters',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MultiDropdown<EventType>(
                  items: widget.eventTypes.map((t) {
                    return DropdownItem(label: t.name, value: t);
                  }).toList(),
                  controller: eventTypeController,
                  enabled: true,
                  searchEnabled: true,
                  chipDecoration: ChipDecoration(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    wrap: true,
                    runSpacing: 2,
                    spacing: 10,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceDim),
                  ),
                  fieldDecoration: FieldDecoration(
                    hintText: 'Event Types',
                    prefixIcon: const Icon(LucideIcons.text_search),
                    showClearIcon: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                  dropdownDecoration: DropdownDecoration(
                    marginTop: 2,
                    maxHeight: 500,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    header: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Select event type from the list',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  dropdownItemDecoration: DropdownItemDecoration(
                    selectedIcon: Icon(Icons.check_box,
                        color: Theme.of(context).colorScheme.surfaceDim),
                    textColor: Colors.black,
                    selectedBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                    selectedTextColor: Colors.black,
                  ),
                  validator: (value) {
                    if (eventTypeController.selectedItems.isEmpty) {
                      return 'Please select an event type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                MultiDropdown<Plant>(
                  items: widget.plants.map((p) {
                    return DropdownItem(label: p.name, value: p);
                  }).toList(),
                  controller: plantController,
                  enabled: true,
                  searchEnabled: true,
                  chipDecoration: ChipDecoration(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    wrap: true,
                    runSpacing: 2,
                    spacing: 10,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceDim),
                  ),
                  fieldDecoration: FieldDecoration(
                    hintText: 'Plants',
                    prefixIcon: const Icon(LucideIcons.text_search),
                    showClearIcon: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    labelStyle: const TextStyle(color: Colors.black),
                  ),
                  dropdownDecoration: DropdownDecoration(
                    marginTop: 2,
                    maxHeight: 500,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    header: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Select plants from the list',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  dropdownItemDecoration: DropdownItemDecoration(
                    selectedIcon: Icon(Icons.check_box,
                        color: Theme.of(context).colorScheme.surfaceDim),
                    textColor: Colors.black,
                    selectedBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                    selectedTextColor: Colors.black,
                  ),
                  validator: (value) {
                    if (eventTypeController.selectedItems.isEmpty) {
                      return 'Please select a plant';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LoadingButton(
                      'Reset',
                      () {
                        eventTypeController.selectAll();
                        widget.callback(widget.eventTypes, widget.plants);
                        Navigator.of(context).pop();
                      },
                      width: MediaQuery.of(context).size.width * .4,
                      buttonColor: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(.8),
                    ),
                    LoadingButton(
                      'Apply',
                      () {
                        if (_formKey.currentState!.validate()) {
                          final List<EventType> eventTypesSelected =
                              eventTypeController.selectedItems
                                  .map((d) => d.value)
                                  .toList();
                          final List<Plant> plantsSelected = plantController
                              .selectedItems
                              .map((p) => p.value)
                              .toList();
                          widget.callback(eventTypesSelected, plantsSelected);
                          Navigator.of(context).pop();
                        }
                      },
                      width: MediaQuery.of(context).size.width * .4,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
