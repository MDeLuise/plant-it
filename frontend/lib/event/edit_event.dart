import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/event_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/dropdown.dart';
import 'package:plant_it/events_notifier.dart';
import 'package:plant_it/theme.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class EditEventPage extends StatefulWidget {
  final Environment env;
  final EventDTO eventDTO;

  const EditEventPage({
    super.key,
    required this.env,
    required this.eventDTO,
  });

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
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
        plantNamesToDiaryIds(widget.env.plants, [_linkedPlant]).first;
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
      if (!mounted) return;
      if (response.statusCode != 200) {
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
    widget.env.logger.info("Event successfully updated");
    showSnackbar(context, ToastificationType.success,
        AppLocalizations.of(context).eventSuccessfullyUpdated);
    Provider.of<EventsNotifier>(context, listen: false).notify();
    Navigator.of(context).pop();
  }

  void _removeEventWithConfirm(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).pleaseConfirm),
            content: Text(AppLocalizations.of(context).areYouSureToRemoveEvent),
            actions: [
              TextButton(
                onPressed: () {
                  _removeEvent();
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context).yes),
              ),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context).no)),
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
      if (!mounted) return;
      if (response.statusCode != 200) {
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
    widget.env.logger.info("Event successfully deleted");
    showSnackbar(context, ToastificationType.success,
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
            tooltip: AppLocalizations.of(context).removeEvent,
            onPressed: () => _removeEventWithConfirm(context),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _updateEvent(),
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
                    options: widget.env.plants
                        .map((e) => e.info.personalName!)
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
                    options: widget.env.eventTypes
                        .map((e) => formatEventType(e))
                        .toList(),
                    onSelectedItemsChanged: (event) {
                      setState(() {
                        _eventType = event;
                      });
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
                        firstDate: DateTime(DateTime.now().year - 1, 1, 1),
                        lastDate: DateTime.now(),
                        builder: datePickerTheme,
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
