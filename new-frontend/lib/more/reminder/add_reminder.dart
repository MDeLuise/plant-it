import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:plant_it/color_banner.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/loading_button.dart';

class AddReminderPage extends StatefulWidget {
  final Environment env;

  const AddReminderPage(this.env, {super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// class _AddReminderPageState extends State<AddReminderPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   String _selectedIcon = "glass_water";
//   String _selectedColor =
//       "#${const Color.fromARGB(255, 50, 115, 52).value.toRadixString(16)}";

//   void _openIconSelector() {
//     showDialog(
//       context: context,
//       builder: (context) => IconSelector(
//         onIconSelected: (iconKey) {
//           setState(() {
//             _selectedIcon = iconKey;
//           });
//         },
//       ),
//     );
//   }

//   Future<void> _saveEvent() async {
//     if (_formKey.currentState!.validate()) {
//       final event = RemindersCompanion(
//         name: drift.Value(_nameController.text),
//         description: drift.Value(_descriptionController.text),
//         icon: drift.Value(_selectedIcon),
//         color: drift.Value(_selectedColor),
//       );

//       try {
//         await widget.env.eventTypeRepository.insert(event);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Event added successfully')),
//         );
//         Navigator.pop(context, true);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Error adding event')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add Event Type')),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             GestureDetector(
//                               onTap: _openIconSelector,
//                               child: CircleAvatar(
//                                 radius: 24,
//                                 child: Icon(
//                                   appIcons[_selectedIcon],
//                                   color:
//                                       Theme.of(context).colorScheme.surfaceDim,
//                                 ),
//                                 backgroundColor: hexToColor(_selectedColor),
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: TextFormField(
//                                 controller: _nameController,
//                                 decoration:
//                                     const InputDecoration(labelText: 'Name'),
//                                 validator: (value) {
//                                   if (value == null || value.isEmpty) {
//                                     return 'Please enter an event name';
//                                   }
//                                   return null;
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 30),
//                         ColorBanner(context, (c) {
//                           String toSet =
//                               colorToHex(Theme.of(context).colorScheme.primary);
//                           if (c != null) {
//                             toSet = colorToHex(c);
//                           }
//                           setState(() {
//                             _selectedColor = toSet;
//                           });
//                         }),
//                         const SizedBox(height: 30),
//                         TextFormField(
//                           controller: _descriptionController,
//                           decoration:
//                               const InputDecoration(labelText: 'Description'),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: LoadingButton(
//                   "Create Reminder",
//                   _saveEvent,
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
