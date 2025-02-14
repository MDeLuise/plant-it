import 'package:flutter/material.dart';
import 'package:plant_it/app_pages.dart';
import 'package:plant_it/color_banner.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/loading_button.dart';

class EditEventTypePage extends StatefulWidget {
  final Environment env;
  final EventType event;

  const EditEventTypePage(this.env, this.event, {super.key});

  @override
  State<EditEventTypePage> createState() => _EditEventTypePageState();
}

class _EditEventTypePageState extends State<EditEventTypePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedIcon = "glass_water";
  String _selectedColor =
      "#${const Color.fromARGB(255, 50, 115, 52).value.toRadixString(16)}";

  @override
  void initState() {
    super.initState();
    if (widget.event.icon != null) {
      _selectedIcon = widget.event.icon!;
    }
    if (widget.event.color != null) {
      _selectedColor = widget.event.color!;
    }
    if (widget.event.description != null) {
      _descriptionController.text = widget.event.description!;
    }
    _nameController.text = widget.event.name;
  }

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

  Future<void> _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      final event = EventType(
        id: widget.event.id,
        name: _nameController.text,
        description: _descriptionController.text,
        icon: _selectedIcon,
        color: _selectedColor,
      );

      try {
        await widget.env.eventTypeRepository.update(event);
        showSnackbar(context, FeedbackLevel.success,
            "Event type updated successfully", null);
        Navigator.pop(context, true);
      } catch (e) {
        showSnackbar(context, FeedbackLevel.error, "Error adding event", null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Edit event type',
      mainActionBtn: LoadingButton(
        "Update",
        _updateEvent,
      ),
      child: Column(
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
                const Text("Name"),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'i.e. watering'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an event type name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
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
                const Text("Description"),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      hintText: 'i.e. Used to track water on plant'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
