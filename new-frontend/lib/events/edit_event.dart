import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/loading_button.dart';

class EditEventScreen extends StatefulWidget {
  final Environment env;
  final Event event;

  const EditEventScreen(this.env, this.event, {super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
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

    selectedDate = widget.event.date;
    if (widget.event.note != null) {
      noteController.text = widget.event.note!;
    }

    // if not in addPostFrameCallback not working, library bug
    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventController.selectWhere(
        (d) => d.value.id == widget.event.type,
      );
      plantController.selectWhere(
        (d) => d.value.id == widget.event.plant,
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        widget.env.eventRepository.update(Event(
          id: widget.event.id,
          type: eventController.selectedItems.first.value.id,
          plant: plantController.selectedItems.first.value.id,
          date: selectedDate,
          note: noteController.text,
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating event')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event updated successfully')),
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
      return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Event"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
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
                        maxSelections: 1,
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
                          // if (value == null || value.isEmpty) {
                          //   return 'Please select an event';
                          // }
                          // return null;
                        },
                        onSelectionChange: (selectedItems) {
                          debugPrint("OnSelectionChange: $selectedItems");
                        },
                      ),
                      const SizedBox(height: 20),
                      MultiDropdown<Plant>(
                        items: plants,
                        maxSelections: 1,
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
                          // if (value == null || value.isEmpty) {
                          //   return 'Please select a plant';
                          // }
                          // return null;
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
                  'Update Event',
                  _updateEvent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
