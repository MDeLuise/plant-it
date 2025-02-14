import 'package:alert_info/alert_info.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:plant_it/app_pages.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/loading_button.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EditEventScreen extends StatefulWidget {
  final Environment env;
  final Event event;

  const EditEventScreen(this.env, this.event, {super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final eventController = MultiSelectController<EventType>();
  final plantController = MultiSelectController<Plant>();
  final TextEditingController noteController = TextEditingController();
  List<DropdownItem<EventType>> events = [];
  List<DropdownItem<Plant>> plants = [];
  bool _isLoading = true;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    await Future.wait([
      widget.env.eventTypeRepository.getAll().then((r) {
        events = r.map((e) => DropdownItem(label: e.name, value: e)).toList();
      }),
      widget.env.plantRepository.getAll().then((r) {
        plants = r.map((e) => DropdownItem(label: e.name, value: e)).toList();
      }),
    ]);

    selectedDate = widget.event.date;
    if (widget.event.note != null) {
      noteController.text = widget.event.note!;
    }

    // if not in addPostFrameCallback not working, library bug
    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventController.selectWhere(
        (d) => d.value.id == widget.event.type,
      );
      plantController.selectWhere(
        (d) => d.value.id == widget.event.plant,
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _updateEvent() async {
    if (_formKey.currentState!.validate()) {
      try {
        await widget.env.eventRepository.update(Event(
          id: widget.event.id,
          type: eventController.selectedItems.first.value.id,
          plant: plantController.selectedItems.first.value.id,
          date: selectedDate,
          note: noteController.text,
        ));
      } catch (e) {
        AlertInfo.show(
          context: context,
          text: 'Error updating event',
          typeInfo: TypeInfo.error,
          duration: 5,
          backgroundColor: Theme.of(context).colorScheme.surface,
          textColor: Theme.of(context).colorScheme.onSurface,
        );
        return;
      }
      AlertInfo.show(
        context: context,
        text: 'Event updated successfully',
        typeInfo: TypeInfo.success,
        duration: 5,
        backgroundColor: Theme.of(context).colorScheme.surface,
        textColor: Theme.of(context).colorScheme.onSurface,
      );
      Navigator.of(context).pop();
    }
  }

  void _deleteEvent() async {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      confirmBtnText: 'Delete',
      cancelBtnText: 'Cancel',
      title: "Delete event?",
      text: "Are you sure you want to delete the event?",
      confirmBtnColor: Colors.red,
      showCancelBtn: true,
      cancelBtnTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      textColor: Theme.of(context).colorScheme.onSurface,
      titleColor: Theme.of(context).colorScheme.onSurface,
      barrierColor: Theme.of(context).colorScheme.surface.withAlpha(200),
      backgroundColor: Theme.of(context).colorScheme.surface,
      onConfirmBtnTap: () {
        try {
          widget.env.eventRepository.delete(widget.event.id);
        } catch (e) {
          AlertInfo.show(
            context: context,
            text: 'Error deleting event',
            typeInfo: TypeInfo.error,
            duration: 5,
            backgroundColor: Theme.of(context).colorScheme.surface,
            textColor: Theme.of(context).colorScheme.onSurface,
          );
          return;
        }
        AlertInfo.show(
          context: context,
          text: 'Event deleted successfully',
          typeInfo: TypeInfo.success,
          duration: 5,
          backgroundColor: Theme.of(context).colorScheme.surface,
          textColor: Theme.of(context).colorScheme.onSurface,
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AppPage(
        title: "Edit an event",
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AppPage(
      title: "Edit an event",
      actions: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ]),
          child: IconButton(
            onPressed: _deleteEvent,
            icon: const Icon(LucideIcons.trash_2),
            iconSize: 18,
          ),
        ),
      ],
      mainActionBtn: LoadingButton(
        'Update',
        _updateEvent,
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 4),

                  // Event
                  Text("Event"),
                  MultiDropdown<EventType>(
                    items: events,
                    controller: eventController,
                    enabled: true,
                    maxSelections: 1,
                    searchEnabled: true,
                    fieldDecoration: FieldDecoration(
                      hintText: "i.e. watering, fertilizing",
                      showClearIcon: false,
                      suffixIcon: null,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).dividerColor, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                    ),
                    dropdownDecoration: DropdownDecoration(
                      maxHeight: 500,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      elevation: 2,
                    ),
                    searchDecoration: const SearchFieldDecoration(
                      searchIcon: Icon(LucideIcons.search),
                    ),
                    validator: (value) {
                      if (eventController.selectedItems.isEmpty) {
                        return 'Please select an event';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Plant
                  Text("Plant"),
                  MultiDropdown<Plant>(
                    items: plants,
                    maxSelections: 1,
                    controller: plantController,
                    enabled: true,
                    searchEnabled: true,
                    fieldDecoration: FieldDecoration(
                      hintText: "i.e. watering, fertilizing",
                      showClearIcon: false,
                      suffixIcon: null,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).dividerColor, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 10),
                    ),
                    dropdownDecoration: DropdownDecoration(
                      maxHeight: 500,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      elevation: 2,
                    ),
                    searchDecoration: const SearchFieldDecoration(
                      searchIcon: Icon(LucideIcons.search),
                    ),
                    validator: (value) {
                      if (plantController.selectedItems.isEmpty) {
                        return 'Please select a plant';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Date
                  Text("Date"),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "",
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).dividerColor, width: 1),
                      ),
                    ),
                    controller: TextEditingController(
                      text: "${selectedDate.toLocal()}".split(' ')[0],
                    ),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 20),

                  // Note field
                  Text("Note"),
                  TextFormField(
                    controller: noteController,
                    decoration: InputDecoration(
                      hintText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
