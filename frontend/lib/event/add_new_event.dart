import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dto/event_dto.dart';
import 'package:plant_it/dto/plant_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/dropdown.dart';
import 'package:plant_it/event/event_card.dart';
import 'package:plant_it/events_notifier.dart';
import 'package:plant_it/theme.dart';
import 'package:plant_it/toast/toast_manager.dart';
import 'package:provider/provider.dart';

class AddNewEventPage extends StatefulWidget {
  final Environment env;
  final PlantDTO? plant;

  const AddNewEventPage({
    super.key,
    required this.env,
    this.plant,
  });

  @override
  State<StatefulWidget> createState() => _AddNewEventPageState();
}

class _AddNewEventPageState extends State<AddNewEventPage> {
  List<String> _linkedPlants = [];
  List<String> _eventTypesToCreate = [];
  DateTime _selectedDate = DateTime.now();
  String? _note;

  Future<void> _addEvent() async {
    await _validate();
    final List<int> plantIds =
        plantNamesToDiaryIds(widget.env.plants, _linkedPlants);
    final List<EventCard> created = [];
    for (var i = 0; i < _eventTypesToCreate.length; i++) {
      for (var j = 0; j < plantIds.length; j++) {
        if (!mounted) return;
        final EventDTO toCreate = EventDTO(
            date: _selectedDate,
            diaryId: plantIds[j],
            type: getBackendEvent(context, _eventTypesToCreate[i]),
            note: _note);
        try {
          final response =
              await widget.env.http.post("diary/entry", toCreate.toMap());
          if (!mounted) return;
          final responseBody = json.decode(response.body);
          if (response.statusCode == 200) {
            created.add(dtoToCard(responseBody, widget.env));
          } else {
            widget.env.logger.error(responseBody["message"]);
            throw AppException(responseBody["message"]);
          }
        } catch (e, st) {
          widget.env.logger.error(e, st);
          throw AppException.withInnerException(e as Exception);
        }
      }
    }
    final int createdEventsNum =
        _eventTypesToCreate.length * _linkedPlants.length;
    widget.env.logger.info("Created $createdEventsNum new event(s)");
    if (!mounted) return;
    widget.env.toastManager.showToast(context, ToastNotificationType.success,
        AppLocalizations.of(context).nEventsCreated(createdEventsNum));
    Provider.of<EventsNotifier>(context, listen: false).notify();
    Navigator.of(context).pop(true);
  }

  Future<void> _validate() {
    String? error;
    if (_linkedPlants.isEmpty) {
      error = AppLocalizations.of(context).selectAtLeastOnePlant;
    } else if (_eventTypesToCreate.isEmpty) {
      error = AppLocalizations.of(context).selectAtLeastOneEvent;
    }
    if (error != null) {
      widget.env.logger.error(error);
      throw AppException(error);
    }
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addNewEvent),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _addEvent(),
        tooltip: AppLocalizations.of(context).addNewEvent,
        child: const Icon(Icons.add_outlined),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    child: TextFieldMultipleDropDown(
                      text: AppLocalizations.of(context).plants,
                      options: widget.env.plants
                          .map((e) => e.info.personalName!)
                          .toList(),
                      onSelectedItemsChanged: (plants) {
                        _linkedPlants = plants;
                      },
                      disabled: widget.plant != null,
                      initialValues: widget.plant != null
                          ? [widget.plant!.info.personalName!]
                          : null,
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
                    child: TextFieldMultipleDropDown(
                      text: AppLocalizations.of(context).events,
                      options: widget.env.eventTypes
                          .map((e) => getLocaleEvent(context, e))
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: TextField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: formatDate(_selectedDate)),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
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
                      maxLines: 4,
                      onChanged: (value) => _note = value,
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
      ),
    );
  }
}
