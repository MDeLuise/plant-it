import 'package:flutter/material.dart';
import 'package:plant_it/ui/core/ui/color_banner.dart';
import 'package:plant_it/ui/settings/view_models/add_event_type_viewmodel.dart';
import 'package:plant_it/utils/common.dart';
import 'package:plant_it/utils/icons.dart';

class AddEventTypeScreen extends StatefulWidget {
  final AddEventTypeViewModel viewModel;

  const AddEventTypeScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<AddEventTypeScreen> createState() => _AddEventTypeScreenState();
}

class _AddEventTypeScreenState extends State<AddEventTypeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Form(
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
        ),
      ),
    );
  }
}
