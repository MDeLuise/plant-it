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

class EditReminder extends StatefulWidget {
  final Environment env;
  final ReminderDTO reminder;

  const EditReminder({
    super.key,
    required this.env,
    required this.reminder,
  });

  @override
  State<EditReminder> createState() => _EditReminderState();
}

class _EditReminderState extends State<EditReminder> {
  late ReminderDTO _toEdit;

  void _updateReminder() async {
    await _validate();
    try {
      final response =
          await widget.env.http.put("reminder/${_toEdit.id}", _toEdit.toMap());
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
        AppLocalizations.of(context).reminderUpdatedSuccessfully);
    Navigator.of(context).pop(true);
  }

  void _removeReminderWithConfirm(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).pleaseConfirm),
            content:
                Text(AppLocalizations.of(context).areYouSureToRemoveReminder),
            actions: [
              TextButton(
                onPressed: () {
                  _removeReminder();
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

  void _removeReminder() async {
    try {
      final response = await widget.env.http.delete("reminder/${_toEdit.id}");
      if (!mounted) return;
      if (response.statusCode != 200) {
        final responseBody = json.decode(response.body);
        widget.env.logger.error(responseBody["message"]);
        throw AppException(responseBody["message"]);
      }
    } catch (e, st) {
      widget.env.logger.error(e, st);
      throw AppException.withInnerException(e as Exception);
    }
    if (!context.mounted) return;
    widget.env.toastManager.showToast(context, ToastNotificationType.success,
        AppLocalizations.of(context).reminderDeletedSuccessfully);
    Navigator.of(context).pop(true);
  }

  Future<void> _validate() {
    String? error;
    if (_toEdit.end != null && _toEdit.end!.isBefore(_toEdit.start!)) {
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
    _toEdit = ReminderDTO.fromJson(widget.reminder.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editReminder),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever_outlined),
            tooltip: AppLocalizations.of(context).removeEvent,
            onPressed: () => _removeReminderWithConfirm(context),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _updateReminder(),
        tooltip: AppLocalizations.of(context).addNewReminder,
        child: const Icon(Icons.save_outlined),
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
                      initialValue: getLocaleEvent(context, _toEdit.action!),
                      text: AppLocalizations.of(context).events,
                      options: widget.env.eventTypes
                          .map((e) => getLocaleEvent(context, e))
                          .toList(),
                      onSelectedItemsChanged: (event) {
                        setState(() {
                          _toEdit.action = getBackendEvent(context, event);
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
                          text: formatDate(_toEdit.start!)),
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _toEdit.start,
                          firstDate: DateTime(DateTime.now().year - 1, 1, 1),
                          lastDate: DateTime(DateTime.now().year + 1, 1, 1),
                          builder: datePickerTheme,
                        );
                        if (pickedDate != null) {
                          _toEdit.start = pickedDate;
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
                      value: _toEdit.end,
                      onChange: (d) => _toEdit.end = d,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: EditableFrequencyInfoEntry(
                      title: AppLocalizations.of(context).frequency,
                      unit: _toEdit.frequency!.unit,
                      value: _toEdit.frequency!.quantity,
                      onChangeUnit: (u) => _toEdit.frequency!.unit = u!,
                      onChangeValue: (q) => _toEdit.frequency!.quantity = q!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: EditableFrequencyInfoEntry(
                      title: AppLocalizations.of(context).repeatAfter,
                      unit: _toEdit.repeatAfter!.unit,
                      value: _toEdit.repeatAfter!.quantity,
                      onChangeUnit: (u) => _toEdit.repeatAfter!.unit = u!,
                      onChangeValue: (q) => _toEdit.repeatAfter!.quantity = q!,
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
