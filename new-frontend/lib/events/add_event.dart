import 'package:easy_loading_button/easy_loading_button.dart';
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
  final controller = MultiSelectController<Event>();
  List<DropdownItem<Event>> items = [
    DropdownItem(label: 'Watering', value: Event(id: 1, name: "watering")),
    DropdownItem(label: 'Seeding', value: Event(id: 2, name: "seeding")),
  ];

  void _saveEvent() async {
    await Future.delayed(const Duration(seconds: 2), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event"),
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
                      const SizedBox(
                        height: 4,
                      ),
                      MultiDropdown<Event>(
                        items: items,
                        controller: controller,
                        enabled: true,
                        searchEnabled: true,
                        chipDecoration: ChipDecoration(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          wrap: true,
                          runSpacing: 2,
                          spacing: 10,
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.surfaceDim),
                        ),
                        fieldDecoration: FieldDecoration(
                            hintText: 'Events',
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                            //prefixIcon: const Icon(LucideIcons.glass_water),
                            showClearIcon: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            labelStyle: TextStyle(
                              color: Colors.black,
                            )),
                        dropdownDecoration: DropdownDecoration(
                          marginTop: 2,
                          maxHeight: 500,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          header: Padding(
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
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                LoadingButton(
                  'Save Events',
                  _saveEvent,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
