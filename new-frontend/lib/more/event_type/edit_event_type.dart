import 'package:flutter/material.dart';
import 'package:plant_it/color_banner.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/loading_button.dart';

class EditEventPage extends StatefulWidget {
  final Environment env;
  final EventType event;

  const EditEventPage(this.env, this.event, {super.key});

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event type updated successfully')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error edit event type')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Event Type')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _openIconSelector,
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: hexToColor(_selectedColor),
                                child: Icon(
                                  appIcons[_selectedIcon],
                                  color:
                                      Theme.of(context).colorScheme.surfaceDim,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _nameController,
                                decoration:
                                    const InputDecoration(labelText: 'Name'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an event name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
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
                        TextFormField(
                          controller: _descriptionController,
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LoadingButton(
                  "Update Event Type",
                  _updateEvent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
