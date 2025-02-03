import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/loading_button.dart';
import 'package:plant_it/more/reminder/frequency_dialog.dart';
import 'package:drift/drift.dart' as drift;

class EditReminderPage extends StatefulWidget {
  final Environment env;
  final Reminder reminder;

  const EditReminderPage(this.env, this.reminder, {super.key});

  @override
  State<EditReminderPage> createState() => _EditReminderPageState();
}

class _EditReminderPageState extends State<EditReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final eventController = MultiSelectController<EventType>();
  final plantController = MultiSelectController<Plant>();

  int _selectedFrequencyQuantity = 1;
  int _selectedRepeatAfterQuantity = 1;
  FrequencyUnit _selectedFrequencyUnit = FrequencyUnit.days;
  FrequencyUnit _selectedRepeatAfterUnit = FrequencyUnit.days;
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _repeatAfterController = TextEditingController();

  List<DropdownItem<EventType>> events = [];
  List<DropdownItem<Plant>> plants = [];
  bool _isLoading = true;
  DateTime selectedStartDate = DateTime.now();
  DateTime? selectedEndDate;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    await Future.wait([
      widget.env.eventTypeRepository.getAll().then((r) {
        events = r.map((e) => DropdownItem(label: e.name, value: e)).toList();
      }),
      widget.env.plantRepository.getAll().then((r) {
        plants = r.map((e) => DropdownItem(label: e.name, value: e)).toList();
      }),
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventController.selectWhere(
        (d) => d.value.id == widget.reminder.type,
      );
      plantController.selectWhere(
        (d) => d.value.id == widget.reminder.plant,
      );
    });

    setState(() {
      _selectedFrequencyQuantity = widget.reminder.frequencyQuantity;
      _selectedFrequencyUnit = widget.reminder.frequencyUnit;
      _selectedRepeatAfterQuantity = widget.reminder.repeatAfterQuantity;
      _selectedRepeatAfterUnit = widget.reminder.repeatAfterUnit;
      _frequencyController.text =
          "Every ${widget.reminder.frequencyQuantity} ${widget.reminder.frequencyUnit.name}";
      _repeatAfterController.text =
          "After ${widget.reminder.repeatAfterQuantity} ${widget.reminder.repeatAfterUnit.name}";
      selectedStartDate = widget.reminder.startDate;
      selectedEndDate = widget.reminder.endDate;
      _isLoading = false;
    });
  }

  void _updateReminder() async {
    if (_formKey.currentState!.validate()) {
      try {
        final selectedEvent = eventController.selectedItems.first.value;
        final selectedPlant = plantController.selectedItems.first.value;
        await widget.env.reminderRepository.insert(RemindersCompanion(
          type: drift.Value(selectedEvent.id),
          plant: drift.Value(selectedPlant.id),
          startDate: drift.Value(selectedStartDate),
          endDate: selectedEndDate != null
              ? drift.Value(selectedEndDate!)
              : const drift.Value.absent(),
          frequencyUnit: drift.Value(_selectedFrequencyUnit),
          frequencyQuantity: drift.Value(_selectedFrequencyQuantity),
          repeatAfterUnit: drift.Value(_selectedRepeatAfterUnit),
          repeatAfterQuantity: drift.Value(_selectedRepeatAfterQuantity),
          enabled: const drift.Value(true),
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminder added successfully')),
        );
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error adding reminder')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          isStart ? selectedStartDate : (selectedEndDate ?? selectedStartDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          selectedStartDate = pickedDate;
        } else {
          selectedEndDate = pickedDate;
        }
      });
    }
  }

  void _showFrequencyDialog(Function(int quantity, FrequencyUnit unit) callback,
      int? selectedQuantity, FrequencyUnit? selectedUnit) async {
    showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (BuildContext context) {
          return FrequencyDialog(
            widget.env,
            callback,
            selectedQuantity,
            selectedUnit,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Update Reminder")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Update Reminder")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Event Dropdown
                  MultiDropdown<EventType>(
                    items: events,
                    controller: eventController,
                    enabled: true,
                    searchEnabled: true,
                    maxSelections: 1,
                    chipDecoration: ChipDecoration(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      wrap: true,
                      runSpacing: 2,
                      spacing: 10,
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    fieldDecoration: FieldDecoration(
                      hintText: 'Select Event',
                      prefixIcon: const Icon(LucideIcons.glass_water),
                      showClearIcon: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    dropdownDecoration: DropdownDecoration(
                      marginTop: 2,
                      maxHeight: 500,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      header: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          'Select events from the list',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    dropdownItemDecoration: DropdownItemDecoration(
                      selectedIcon: Icon(Icons.check_box,
                          color: Theme.of(context).colorScheme.surfaceDim),
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      selectedBackgroundColor:
                          Theme.of(context).colorScheme.primary,
                      selectedTextColor:
                          Theme.of(context).colorScheme.onPrimary,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select an event'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Plant Dropdown
                  MultiDropdown<Plant>(
                    items: plants,
                    controller: plantController,
                    enabled: true,
                    searchEnabled: true,
                    maxSelections: 1,
                    chipDecoration: ChipDecoration(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      wrap: true,
                      runSpacing: 2,
                      spacing: 10,
                      labelStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please select a plant'
                        : null,
                    fieldDecoration: FieldDecoration(
                      hintText: 'Plants',
                      prefixIcon: const Icon(LucideIcons.leaf),
                      showClearIcon: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                    dropdownDecoration: DropdownDecoration(
                      marginTop: 2,
                      maxHeight: 500,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      header: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Select plants from the list',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    dropdownItemDecoration: DropdownItemDecoration(
                      selectedIcon: Icon(Icons.check_box,
                          color: Theme.of(context).colorScheme.surfaceDim),
                      textColor: Colors.black,
                      selectedBackgroundColor:
                          Theme.of(context).colorScheme.primary,
                      selectedTextColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Dates
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "Start Date",
                            prefixIcon: const Icon(LucideIcons.calendar),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          controller: TextEditingController(
                            text:
                                "${selectedStartDate.toLocal()}".split(' ')[0],
                          ),
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "No End",
                            prefixIcon: const Icon(LucideIcons.calendar),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          controller: TextEditingController(
                            text: selectedEndDate != null
                                ? "${selectedEndDate!.toLocal()}".split(' ')[0]
                                : "",
                          ),
                          onTap: () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Frequency
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Frequency",
                      prefixIcon: const Icon(LucideIcons.clock),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onTap: () => _showFrequencyDialog(
                      (q, u) {
                        setState(() {
                          _selectedFrequencyUnit = u;
                          _selectedFrequencyQuantity = q;
                          _frequencyController.text = "Every $q ${u.name}";
                        });
                      },
                      _selectedFrequencyQuantity,
                      _selectedFrequencyUnit,
                    ),
                    controller: _frequencyController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Repeat After
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: "Repeat After",
                      prefixIcon: const Icon(LucideIcons.repeat),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onTap: () => _showFrequencyDialog(
                      (q, u) {
                        setState(() {
                          _selectedRepeatAfterUnit = u;
                          _selectedRepeatAfterQuantity = q;
                        });
                        _repeatAfterController.text = "After $q ${u.name}";
                      },
                      _selectedRepeatAfterQuantity,
                      _selectedRepeatAfterUnit,
                    ),
                    controller: _repeatAfterController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a value';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 40),

                  // Save Button
                  LoadingButton('Update Reminder', _updateReminder),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
