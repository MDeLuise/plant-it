import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:plant_it/app_pages.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:flutter/material.dart';
import 'package:plant_it/loading_button.dart';
import 'package:plant_it/more/reminder/frequency_dialog.dart';
import 'package:drift/drift.dart' as drift;

class AddReminderPage extends StatefulWidget {
  final Environment env;

  const AddReminderPage(this.env, {super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final _formKey = GlobalKey<FormState>();
  final eventController = MultiSelectController<EventType>();
  final plantController = MultiSelectController<Plant>();

  int seelctedFrequencyQuantity = 1;
  int seelctedRepeatAfterQuantity = 1;
  FrequencyUnit selectedFrequencyUnit = FrequencyUnit.days;
  FrequencyUnit selectedRepeatAfterUnit = FrequencyUnit.days;
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

    setState(() => _isLoading = false);
  }

  void _saveReminder() async {
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
          frequencyUnit: drift.Value(selectedFrequencyUnit),
          frequencyQuantity: drift.Value(seelctedFrequencyQuantity),
          repeatAfterUnit: drift.Value(selectedRepeatAfterUnit),
          repeatAfterQuantity: drift.Value(seelctedRepeatAfterQuantity),
          enabled: const drift.Value(true),
        ));

        showSnackbar(context, FeedbackLevel.success,
            "Reminder added successfully", null);
        Navigator.of(context).pop(true);
      } catch (e) {
        showSnackbar(
            context, FeedbackLevel.error, "Error adding reminder", null);
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
        appBar: AppBar(title: const Text("Add Reminder")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return AppPage(
      title: 'Add a new reminder',
      mainActionBtn: LoadingButton('Save', _saveReminder),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Event Dropdown
            const Text("Event type"),
            MultiDropdown<EventType>(
              items: events,
              controller: eventController,
              enabled: true,
              searchEnabled: true,
              maxSelections: 1,
              fieldDecoration: FieldDecoration(
                hintText: "i.e. watering, fertilizing",
                showClearIcon: false,
                suffixIcon: null,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).dividerColor, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              ),
              dropdownDecoration: DropdownDecoration(
                maxHeight: 500,
                backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                elevation: 2,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              searchDecoration: const SearchFieldDecoration(
                searchIcon: Icon(LucideIcons.search),
              ),
              chipDecoration: const ChipDecoration(
                  labelStyle: TextStyle(
                color: Colors.black87,
              )),
              dropdownItemDecoration: DropdownItemDecoration(
                selectedBackgroundColor: const Color(0xFFE0E0E0),
                selectedTextColor: Colors.black87,
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select an event'
                  : null,
            ),
            const SizedBox(height: 20),

            // Plant Dropdown
            const Text("Plant"),
            MultiDropdown<Plant>(
              items: plants,
              controller: plantController,
              enabled: true,
              searchEnabled: true,
              maxSelections: 1,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please select a plant'
                  : null,
              fieldDecoration: FieldDecoration(
                hintText: "i.e. watering, fertilizing",
                showClearIcon: false,
                suffixIcon: null,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).dividerColor, width: 1),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              ),
              dropdownDecoration: DropdownDecoration(
                maxHeight: 500,
                backgroundColor: Theme.of(context).colorScheme.surfaceBright,
                elevation: 2,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              chipDecoration: const ChipDecoration(
                  labelStyle: TextStyle(
                color: Colors.black87,
              )),
              dropdownItemDecoration: DropdownItemDecoration(
                selectedBackgroundColor:
                    Theme.of(context).colorScheme.onSurface,
                selectedTextColor: Colors.black87,
              ),
              searchDecoration: const SearchFieldDecoration(
                searchIcon: Icon(LucideIcons.search),
              ),
            ),
            const SizedBox(height: 20),

            // Dates
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Start"),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "",
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1),
                          ),
                        ),
                        controller: TextEditingController(
                          text: "${selectedStartDate.toLocal()}".split(' ')[0],
                        ),
                        onTap: () => _selectDate(context, true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("End"),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "No End",
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1),
                          ),
                        ),
                        controller: TextEditingController(
                          text: selectedEndDate != null
                              ? "${selectedEndDate!.toLocal()}".split(' ')[0]
                              : "",
                        ),
                        onTap: () => _selectDate(context, false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Frequency
            const Text("Frequency"),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: "i.e. every 3 weeks",
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).dividerColor, width: 1),
                ),
              ),
              onTap: () => _showFrequencyDialog(
                (q, u) {
                  setState(() {
                    selectedFrequencyUnit = u;
                    seelctedFrequencyQuantity = q;
                    _frequencyController.text = "Every $q ${u.name}";
                  });
                },
                seelctedFrequencyQuantity,
                selectedFrequencyUnit,
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
            const Text("Repetition"),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: "i.e. after 2 days",
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).dividerColor, width: 1),
                ),
              ),
              onTap: () => _showFrequencyDialog(
                (q, u) {
                  setState(() {
                    selectedRepeatAfterUnit = u;
                    seelctedRepeatAfterQuantity = q;
                  });
                  _repeatAfterController.text = "After $q ${u.name}";
                },
                seelctedRepeatAfterQuantity,
                selectedRepeatAfterUnit,
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
          ],
        ),
      ),
    );
  }
}
