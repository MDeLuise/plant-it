import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/app_exception.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/dropdown.dart';
import 'package:plant_it/dto/reminder_dto.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/info_entries.dart';
import 'package:plant_it/theme.dart';
import 'package:plant_it/toast/toast_manager.dart';

class AddReminder extends StatefulWidget {
  final Environment env;
  final int targetId;

  const AddReminder({
    super.key,
    required this.env,
    required this.targetId,
  });

  @override
  State<AddReminder> createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder> {
  late ReminderDTO _toCreate;
  late DateTime _selectedStartDate;
  DateTime? _selectedEndDate;

  void _createReminder() async {
    await _validate();
    try {
      final response =
          await widget.env.http.post("reminder", _toCreate.toMap());
      if (!mounted) return;
      final responseBody = json.decode(response.body);
      if (response.statusCode != 200) {
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
    if (!mounted) return;
    widget.env.toastManager.showToast(context, ToastNotificationType.success,
        AppLocalizations.of(context).reminderCreatedSuccessfully);
    Navigator.of(context).pop(true);
  }

  Future<void> _validate() {
    String? error;
    if (_toCreate.end != null && _toCreate.end!.isBefore(_toCreate.start!)) {
      error = AppLocalizations.of(context).startAndEndDateOrderError;
    }
    if (error != null) {
      widget.env.logger.error(error);
      throw AppException(error);
    }
    return Future.value();
  }

  @override
  void initState() {
    super.initState();
    _toCreate = ReminderDTO(
      action: "WATERING",
      enabled: true,
      start: DateTime.now(),
      frequency: FrequencyDTO(quantity: 3, unit: Unit.days),
      repeatAfter: FrequencyDTO(quantity: 5, unit: Unit.days),
      targetId: widget.targetId,
    );
    _selectedStartDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addNewReminder),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createReminder(),
        tooltip: AppLocalizations.of(context).addNewReminder,
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
                      AppLocalizations.of(context).selectEvents,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldSingleDropDown(
                      initialValue: getLocaleEvent(context, "watering"),
                      text: AppLocalizations.of(context).events,
                      options: widget.env.eventTypes
                          .map((e) => formatEventType(e))
                          .toList(),
                      onSelectedItemsChanged: (event) {
                        setState(() {
                          _toCreate.action = getBackendEvent(context, event);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      AppLocalizations.of(context).selectStartDate,
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
                          text: formatDate(_selectedStartDate)),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 1, 1, 1),
                          lastDate: DateTime(DateTime.now().year + 1, 1, 1),
                          builder: datePickerTheme,
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedStartDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: EditableDateInfoEntry(
                      title: AppLocalizations.of(context).selectEndDate,
                      emptyHint: AppLocalizations.of(context).noEndDate,
                      value: _selectedEndDate,
                      onChange: (d) => _toCreate.end = d,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: EditableFrequencyInfoEntry(
                      title: AppLocalizations.of(context).frequency,
                      unit: Unit.days,
                      value: 3,
                      onChangeUnit: (u) => _toCreate.frequency!.unit = u!,
                      onChangeValue: (q) => _toCreate.frequency!.quantity = q!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: EditableFrequencyInfoEntry(
                      title: AppLocalizations.of(context).repeatAfter,
                      unit: Unit.days,
                      value: 5,
                      onChangeUnit: (u) => _toCreate.repeatAfter!.unit = u!,
                      onChangeValue: (q) =>
                          _toCreate.repeatAfter!.quantity = q!,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
