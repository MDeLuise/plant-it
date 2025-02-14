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
  final Function(List<int>?, List<int>?, ActivityFilterType?) callback;
  final ScrollController? scrollController;

  const ActivityFilter(
    this.env,
    this.callback,
    this.filteredPlantIds,
    this.filteredEventTypesIds,
    this.activityFilterType, {
    this.scrollController,
    super.key,
  });

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
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(
                  'Filters',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // Type
                const Text("Type"),
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
                  fieldDecoration: FieldDecoration(
                    hintText: "i.e. Reminders",
                    showClearIcon: false,
                    suffixIcon: null,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 1),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  ),
                  dropdownDecoration: DropdownDecoration(
                    maxHeight: 500,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    elevation: 2,
                  ),
                  searchDecoration: const SearchFieldDecoration(
                    searchIcon: Icon(LucideIcons.search),
                  ),
                  chipDecoration: const ChipDecoration(
                      labelStyle: TextStyle(
                    color: Colors.black87,
                  )),
                  validator: (value) {
                    if (activityTypeController.selectedItems.isEmpty) {
                      return 'Please an activity type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Event
                const Text("Events"),
                MultiDropdown<EventType>(
                  items: events,
                  controller: eventController,
                  enabled: true,
                  searchEnabled: true,
                  fieldDecoration: FieldDecoration(
                    hintText: "i.e. watering",
                    showClearIcon: false,
                    suffixIcon: null,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 1),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  ),
                  dropdownDecoration: DropdownDecoration(
                    maxHeight: 500,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    elevation: 2,
                  ),
                  searchDecoration: const SearchFieldDecoration(
                    searchIcon: Icon(LucideIcons.search),
                  ),
                  chipDecoration: const ChipDecoration(
                      labelStyle: TextStyle(
                    color: Colors.black87,
                  )),
                  validator: (value) {
                    if (eventController.selectedItems.isEmpty) {
                      return 'Please select an event type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Plants
                const Text("Plant"),
                MultiDropdown<Plant>(
                  items: plants,
                  controller: plantController,
                  enabled: true,
                  searchEnabled: true,
                  fieldDecoration: FieldDecoration(
                    hintText: "i.e. Strelitzia nicolai",
                    showClearIcon: false,
                    suffixIcon: null,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 1),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  ),
                  dropdownDecoration: DropdownDecoration(
                    maxHeight: 500,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    elevation: 2,
                  ),
                  searchDecoration: const SearchFieldDecoration(
                    searchIcon: Icon(LucideIcons.search),
                  ),
                  chipDecoration: const ChipDecoration(
                      labelStyle: TextStyle(
                    color: Colors.black87,
                  )),
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
