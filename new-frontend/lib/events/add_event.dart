import 'package:drift/drift.dart' as drift;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/loading_button.dart';

class AddEventScreen extends StatefulWidget {
  final Environment env;

  const AddEventScreen(this.env, {super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final eventController = MultiSelectController<EventType>();
  final plantController = MultiSelectController<Plant>();
  final TextEditingController noteController = TextEditingController();
  List<DropdownItem<EventType>> events = [];
  List<DropdownItem<Plant>> plants = [];
  bool _isLoading = true;
  DateTime selectedDate = DateTime.now();

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

    setState(() {
      _isLoading = false;
    });
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        for (var e in eventController.selectedItems) {
          for (var p in plantController.selectedItems) {
            widget.env.eventRepository.insert(EventsCompanion(
              type: drift.Value(e.value.id),
              plant: drift.Value(p.value.id),
              date: drift.Value(selectedDate),
              note: drift.Value(
                  noteController.text.isEmpty ? null : noteController.text),
            ));
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error adding events')),
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Events added successfully')),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // Display a loading indicator while fetching data
      return Scaffold(
        appBar: AppBar(
          title: const Text("Add Event"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Once loading is complete, display the UI
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(height: 4),
                      MultiDropdown<EventType>(
                        items: events,
                        controller: eventController,
                        enabled: true,
                        searchEnabled: true,
                        chipDecoration: ChipDecoration(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          wrap: true,
                          runSpacing: 2,
                          spacing: 10,
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.surfaceDim),
                        ),
                        fieldDecoration: FieldDecoration(
                          hintText: 'Events',
                          // hintStyle: TextStyle(
                          //     color: Theme.of(context).colorScheme.primary),
                          prefixIcon: const Icon(LucideIcons.glass_water),
                          showClearIcon: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors
                                  .grey, // Theme.of(context).colorScheme.primary),
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
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          header: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Select events from the list',
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
                          if (value == null || value.isEmpty) {
                            return 'Please select an event';
                          }
                          return null;
                        },
                        onSelectionChange: (selectedItems) {
                          debugPrint("OnSelectionChange: $selectedItems");
                        },
                      ),
                      const SizedBox(height: 20),
                      MultiDropdown<Plant>(
                        items: plants,
                        controller: plantController,
                        enabled: true,
                        searchEnabled: true,
                        chipDecoration: ChipDecoration(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          wrap: true,
                          runSpacing: 2,
                          spacing: 10,
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.surfaceDim),
                        ),
                        fieldDecoration: FieldDecoration(
                          hintText: 'Plants',
                          // hintStyle: TextStyle(
                          //     color: Theme.of(context).colorScheme.primary),
                          prefixIcon: const Icon(LucideIcons.leaf),
                          showClearIcon: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors
                                  .grey, // Theme.of(context).colorScheme.primary),
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
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
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
                          if (value == null || value.isEmpty) {
                            return 'Please select a plant';
                          }
                          return null;
                        },
                        onSelectionChange: (selectedItems) {
                          debugPrint("OnSelectionChange: $selectedItems");
                        },
                      ),
                      const SizedBox(height: 20),
                      // Date picker
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Date",
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        controller: TextEditingController(
                          text: "${selectedDate.toLocal()}".split(' ')[0],
                        ),
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 20),
                      // Note field
                      TextFormField(
                        controller: noteController,
                        decoration: InputDecoration(
                          hintText: "Note",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                LoadingButton(
                  'Save Events',
                  _saveEvent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
