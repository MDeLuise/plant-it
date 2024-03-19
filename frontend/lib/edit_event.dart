import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/event_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/dropdown.dart';
import 'package:plant_it/events_notifier.dart';
import 'package:provider/provider.dart';

class EditEventPage extends StatefulWidget {
  final Environment env;
  final EventDTO eventDTO;

  const EditEventPage({super.key, required this.env, required this.eventDTO});

  @override
  State<EditEventPage> createState() => _EditEventPage();
}

class _EditEventPage extends State<EditEventPage> {
  late String _linkedPlant;
  late String _eventType;
  final TextEditingController _noteController = TextEditingController();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _linkedPlant = widget.eventDTO.plantName!;
    _eventType = widget.eventDTO.type;
    if (widget.eventDTO.note != null) {
      _noteController.text = widget.eventDTO.note!;
    }
    _selectedDate = widget.eventDTO.date;
  }

  void _updateEvent() async {
    final int plantDiaryId =
        plantNamesToDiaryIds(widget.env.plants!, [_linkedPlant]).first;
    final EventDTO updated = EventDTO(
      id: widget.eventDTO.id,
      date: _selectedDate,
      diaryId: plantDiaryId,
      type: getBackendEvent(context, _eventType),
      note: _noteController.text,
    );
    try {
      final response = await widget.env.http
          .put("diary/entry/${updated.id}", updated.toMap());
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        showSnackbar(context, SnackBarType.fail, responseBody["message"]);
        return;
      }
    } catch (e) {
      showSnackbar(context, SnackBarType.fail, e.toString());
    }

    showSnackbar(context, SnackBarType.success,
        AppLocalizations.of(context).eventSuccessfullyUpdated);
    Provider.of<EventsNotifier>(context, listen: false).notify();
    Navigator.of(context).pop();
  }

  void _removeEventWithConfirm() async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to remove the reminder?'),
            actions: [
              TextButton(
                  onPressed: () {
                    _removeEvent();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  void _removeEvent() async {
    try {
      final response = await widget.env.http.delete(
        "diary/entry/${widget.eventDTO.id}",
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        showSnackbar(context, SnackBarType.fail, responseBody["message"]);
        return;
      }
    } catch (e) {
      showSnackbar(context, SnackBarType.fail, e.toString());
    }

    showSnackbar(context, SnackBarType.success,
        AppLocalizations.of(context).eventSuccessfullyDeleted);
    Provider.of<EventsNotifier>(context, listen: false).notify();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editEvent),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_outlined),
            tooltip: 'Remove reminder',
            onPressed: _removeEventWithConfirm,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _updateEvent(),
        backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
        shape: const CircleBorder(),
        tooltip: AppLocalizations.of(context).addNewEvent,
        child: const Icon(Icons.save_outlined),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    AppLocalizations.of(context).selectPlants,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldSingleDropDown(
                    initialValue: _linkedPlant,
                    text: AppLocalizations.of(context).plants,
                    options: widget.env.plants!
                        .map((e) => e.info.personalName)
                        .toList(),
                    onSelectedItemsChanged: (plant) {
                      _linkedPlant = plant;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    AppLocalizations.of(context).selectEvents,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldSingleDropDown(
                    initialValue: formatEventType(_eventType),
                    text: AppLocalizations.of(context).events,
                    options: widget.env.eventTypes!
                        .map((e) => formatEventType(e))
                        .toList(),
                    onSelectedItemsChanged: (event) {
                      _eventType = event;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    AppLocalizations.of(context).selectDate,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: TextField(
                    readOnly: true,
                    controller:
                        TextEditingController(text: formatDate(_selectedDate)),
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    AppLocalizations.of(context).addNote,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 4,
                    onChanged: (value) => _noteController.text = value,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: AppLocalizations.of(context).enterNote,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
