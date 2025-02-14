import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:plant_it/app_pages.dart';
import 'package:plant_it/color_banner.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/loading_button.dart';

class AddEventTypePage extends StatefulWidget {
  final Environment env;

  const AddEventTypePage(this.env, {super.key});

  @override
  State<AddEventTypePage> createState() => _AddEventTypePageState();
}

class _AddEventTypePageState extends State<AddEventTypePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedIcon = "glass_water";
  String _selectedColor =
      "#${const Color.fromARGB(255, 50, 115, 52).value.toRadixString(16)}";

  void _openIconSelector() {
    showDialog(
      context: context,
      builder: (context) => IconSelector(
        onIconSelected: (iconKey) {
          setState(() {
            _selectedIcon = iconKey;
          });
        },
      ),
    );
  }

  Future<void> _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final event = EventTypesCompanion(
        name: drift.Value(_nameController.text),
        description: drift.Value(_descriptionController.text),
        icon: drift.Value(_selectedIcon),
        color: drift.Value(_selectedColor),
      );

      try {
        await widget.env.eventTypeRepository.insert(event);
        showSnackbar(context, FeedbackLevel.success, "Event added successfully", null);
        Navigator.pop(context, true);
      } catch (e) {
        showSnackbar(context, FeedbackLevel.error, "Error adding event", null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Add a new event type',
      mainActionBtn: LoadingButton(
        "Create",
        _saveEvent,
      ),
      closeOnBack: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _openIconSelector,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: hexToColor(_selectedColor),
                        child: Icon(
                          appIcons[_selectedIcon],
                          color: Theme.of(context).colorScheme.surfaceDim,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Name
                const Text("Name"),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'i.e. watering'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),

                // Color
                const Text("Color"),
                ColorBanner(context, (c) {
                  String toSet =
                      colorToHex(Theme.of(context).colorScheme.primary);
                  if (c != null) {
                    toSet = colorToHex(c);
                  }
                  setState(() {
                    _selectedColor = toSet;
                  });
                }),
                const SizedBox(height: 30),

                // Description
                const Text("Description"),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'i.e. Used to track water on plant',
                  ),
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
