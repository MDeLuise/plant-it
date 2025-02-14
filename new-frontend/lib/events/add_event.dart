import 'package:drift/drift.dart' as drift;
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:plant_it/app_pages.dart';
import 'package:plant_it/common.dart';
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
            await widget.env.eventRepository.insert(EventsCompanion(
              type: drift.Value(e.value.id),
              plant: drift.Value(p.value.id),
              date: drift.Value(selectedDate),
              note: drift.Value(
                  noteController.text.isEmpty ? null : noteController.text),
            ));
          }
        }
      } catch (e) {
        showSnackbar(context, FeedbackLevel.error, "Error adding event", null);
      }
      showSnackbar(
          context, FeedbackLevel.success, "Events added successfully", null);
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
    return AppPage(
      title: "Add new events",
      mainActionBtn: LoadingButton(
        'Save',
        _saveEvent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 4),

                // Event
                const Text("Events"),
                MultiDropdown<EventType>(
                  items: events,
                  controller: eventController,
                  enabled: true,
                  searchEnabled: true,
                  fieldDecoration: FieldDecoration(
                    hintText: "i.e. watering, fertilizing",
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
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceBright,
                    elevation: 2,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  searchDecoration: const SearchFieldDecoration(
                    searchIcon: Icon(LucideIcons.search),
                  ),
                  chipDecoration: const ChipDecoration(
                      labelStyle: TextStyle(
                    color: Colors.black87,
                  )),
                  dropdownItemDecoration: DropdownItemDecoration(
                    selectedBackgroundColor: const Color(0xFFE0E0E0),
                    selectedTextColor: Colors.black87,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an event';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Plant
                const Text("Plants"),
                MultiDropdown<Plant>(
                  items: plants,
                  controller: plantController,
                  enabled: true,
                  searchEnabled: true,
                  fieldDecoration: FieldDecoration(
                    hintText: "i.e. Monstera deliciosa",
                    showClearIcon: false,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 1),
                    ),
                    suffixIcon: null,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  ),
                  dropdownDecoration: DropdownDecoration(
                    maxHeight: 500,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceBright,
                    elevation: 2,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  chipDecoration: const ChipDecoration(
                      labelStyle: TextStyle(
                    color: Colors.black87,
                  )),
                  dropdownItemDecoration: DropdownItemDecoration(
                    selectedBackgroundColor:
                        Theme.of(context).colorScheme.onSurface,
                    selectedTextColor: Colors.black87,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a plant';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Date
                const Text("Date"),
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "",
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).dividerColor, width: 1),
                    ),
                  ),
                  controller: TextEditingController(
                    text: "${selectedDate.toLocal()}".split(' ')[0],
                  ),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 30),

                // Note
                const Text("Note"),
                const SizedBox(height: 5),
                TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
