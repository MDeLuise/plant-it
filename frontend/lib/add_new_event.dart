import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/event_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/multiple_dropdown.dart';

class AddNewEventPage extends StatefulWidget {
  final Environment env;

  const AddNewEventPage({super.key, required this.env});

  @override
  State<StatefulWidget> createState() => _AddNewEventPage();
}

class _AddNewEventPage extends State<AddNewEventPage> {
  final DateFormat dateFormat = DateFormat('dd/MM/yy');
  List<String> _linkedPlants = [];
  List<String> _eventTypesToCreate = [];
  DateTime _selectedDate = DateTime.now();
  String? _note;

  List<int> _plantNamesToDiaryIds(List<String> names) {
    final List<int> plantIds = [];
    for (var i = 0; i < names.length; i++) {
      for (var j = 0; j < widget.env.plants!.length; j++) {
        if (widget.env.plants![j].info.personalName == names[i]) {
          plantIds.add(widget.env.plants![j].diaryId!);
        }
      }
    }
    return plantIds;
  }

  void _addEvent() async {
    if (!_validate()) {
      return;
    }
    final List<int> plantIds = _plantNamesToDiaryIds(_linkedPlants);
    for (var i = 0; i < _eventTypesToCreate.length; i++) {
      for (var j = 0; j < plantIds.length; j++) {
        final EventDTO toCreate = EventDTO(
            date: _selectedDate,
            diaryId: plantIds[j],
            type: formatEvent(context, _eventTypesToCreate[i]),
            note: _note);
        try {
          final response =
              await widget.env.http.post("diary/entry", toCreate.toMap());
          final responseBody = json.decode(response.body);
          if (response.statusCode != 200) {
            showSnackbar(context, SnackBarType.fail, responseBody["message"]);
            return;
          }
        } catch (e) {
          showSnackbar(context, SnackBarType.fail, e.toString());
        }
      }
    }
    final int createdEventsNum =
        _eventTypesToCreate.length * _linkedPlants.length;
    showSnackbar(context, SnackBarType.save,
        AppLocalizations.of(context).nEventsCreated(createdEventsNum));
    Navigator.of(context).pop();
  }

  bool _validate() {
    String? error;
    if (_linkedPlants.isEmpty) {
      error = AppLocalizations.of(context).selectAtLeastOnePlant;
    } else if (_eventTypesToCreate.isEmpty) {
      error = AppLocalizations.of(context).selectAtLeastOneEvent;
    }
    if (error != null) {
      showSnackbar(context, SnackBarType.fail, error);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addNewEvent),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEvent(),
        tooltip: AppLocalizations.of(context).addNewEvent,
        child: const Icon(Icons.add),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldWithDropDown(
                    text: AppLocalizations.of(context).plants,
                    options: widget.env.plants!
                        .map((e) => e.info.personalName)
                        .toList(),
                    onSelectedItemsChanged: (plants) {
                      _linkedPlants = plants;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    AppLocalizations.of(context).selectEvents,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldWithDropDown(
                    text: AppLocalizations.of(context).events,
                    options: widget.env.eventTypes!
                        .map((e) => formatEventType(e))
                        .toList(),
                    onSelectedItemsChanged: (events) {
                      _eventTypesToCreate = events;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    AppLocalizations.of(context).selectDate,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController(
                        text: dateFormat.format(_selectedDate)),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
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
