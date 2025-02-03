import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/loading_button.dart';

enum ActivityFilterType {
  reminders,
  events;
}

class ActivityFilter extends StatefulWidget {
  final Environment env;
  final List<int>? filteredPlantIds;
  final List<int>? filteredEventTypesIds;
  final ActivityFilterType? activityFilterType;

  final Function(List<int>? plantIds, List<int>? eventTypeIds,
      ActivityFilterType? activityType) callback;

  const ActivityFilter(this.env, this.callback, this.filteredPlantIds,
      this.filteredEventTypesIds, this.activityFilterType,
      {super.key});

  @override
  State<ActivityFilter> createState() => _ActivityFilterState();
}

class _ActivityFilterState extends State<ActivityFilter> {
  final _formKey = GlobalKey<FormState>();
  final activityTypeController = MultiSelectController<ActivityFilterType>();
  final eventController = MultiSelectController<EventType>();
  final plantController = MultiSelectController<Plant>();
  List<DropdownItem<EventType>> events = [];
  List<DropdownItem<Plant>> plants = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.wait([
      widget.env.eventTypeRepository.getAll().then((r) {
        events = r.map((e) => DropdownItem(label: e.name, value: e)).toList();
      }),
      widget.env.plantRepository.getAll().then((r) {
        plants = r.map((e) => DropdownItem(label: e.name, value: e)).toList();
      }),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.filteredEventTypesIds == null) {
        eventController.selectAll();
      } else {
        eventController.selectWhere(
            (e) => widget.filteredEventTypesIds!.contains(e.value.id));
      }
      if (widget.filteredPlantIds == null) {
        plantController.selectAll();
      } else {
        plantController
            .selectWhere((p) => widget.filteredPlantIds!.contains(p.value.id));
      }
      if (widget.activityFilterType == null) {
        activityTypeController.selectAll();
      } else {
        activityTypeController
            .selectWhere((p) => p.value == widget.activityFilterType);
      }
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Display a loading indicator while fetching data
      return SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                MultiDropdown<ActivityFilterType>(
                  items: [
                    DropdownItem(
                      label: "Reminders",
                      value: ActivityFilterType.reminders,
                    ),
                    DropdownItem(
                      label: "Events",
                      value: ActivityFilterType.events,
                    ),
                  ],
                  controller: activityTypeController,
                  enabled: true,
                  searchEnabled: true,
                  chipDecoration: ChipDecoration(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    wrap: true,
                    runSpacing: 2,
                    spacing: 10,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  fieldDecoration: FieldDecoration(
                    hintText: 'Activity',
                    prefixIcon: const Icon(LucideIcons.calendar),
                    showClearIcon: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey)),
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    header: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Select activity type from the list',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  dropdownItemDecoration: DropdownItemDecoration(
                    selectedIcon: Icon(Icons.check_box,
                        color: Theme.of(context).colorScheme.onPrimary),
                    textColor: Colors.black,
                    selectedBackgroundColor:
                        Theme.of(context).colorScheme.primary,
                    selectedTextColor: Colors.black,
                  ),
                  validator: (value) {
                    if (activityTypeController.selectedItems.isEmpty) {
                      return 'Please an activity type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                MultiDropdown<EventType>(
                  items: events,
                  controller: eventController,
                  enabled: true,
                  searchEnabled: true,
                  chipDecoration: ChipDecoration(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    wrap: true,
                    runSpacing: 2,
                    spacing: 10,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  fieldDecoration: FieldDecoration(
                    hintText: 'Events',
                    prefixIcon: const Icon(LucideIcons.glass_water),
                    showClearIcon: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        )),
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    header: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Select events from the list',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
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
                    if (eventController.selectedItems.isEmpty) {
                      return 'Please select an event';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                MultiDropdown<Plant>(
                  items: plants,
                  controller: plantController,
                  enabled: true,
                  searchEnabled: true,
                  chipDecoration: ChipDecoration(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    wrap: true,
                    runSpacing: 2,
                    spacing: 10,
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  fieldDecoration: FieldDecoration(
                    hintText: 'Plants',
                    prefixIcon: const Icon(LucideIcons.leaf),
                    showClearIcon: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        )),
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    header: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Select plants from the list',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
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
                    if (plantController.selectedItems.isEmpty) {
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
                        eventController.selectAll();
                        plantController.selectAll();
                        activityTypeController.selectAll();
                        widget.callback(null, null, null);
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
                        final List<int> plantIds = plantController.selectedItems
                            .map((d) => d.value.id)
                            .toList();
                        final List<int> eventTypeIds = eventController
                            .selectedItems
                            .map((d) => d.value.id)
                            .toList();
                        ActivityFilterType? activityFilterType;
                        if (activityTypeController.selectedItems.length == 1) {
                          activityFilterType =
                              activityTypeController.selectedItems.first.value;
                        }
                        if (_formKey.currentState!.validate()) {
                          widget.callback(
                              plantIds, eventTypeIds, activityFilterType);
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
