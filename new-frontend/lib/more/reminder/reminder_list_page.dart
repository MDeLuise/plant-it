import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:plant_it/common.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/icons.dart';
import 'package:plant_it/more/reminder/add_reminder.dart';
import 'package:plant_it/more/reminder/edit_reminder.dart';
import 'package:plant_it/more/reminder/reminder_filter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ReminderListPage extends StatefulWidget {
  final Environment env;
  final Plant? plant;

  const ReminderListPage(this.env, this.plant, {super.key});

  @override
  State<ReminderListPage> createState() => _RemindersListPageState();
}

class _RemindersListPageState extends State<ReminderListPage> {
  final Map<int, EventType> _eventTypes = {};
  final Map<int, Plant> _plants = {};
  List<EventType> _selectedEventTypes = [];
  List<Plant> _selectedPlants = [];
  List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    widget.env.eventTypeRepository.getAll().then((rl) {
      for (EventType t in rl) {
        _eventTypes[t.id] = t;
        _selectedEventTypes.add(t);
      }
    });
    widget.env.plantRepository.getAll().then((rl) {
      for (Plant p in rl) {
        _plants[p.id] = p;
        if (widget.plant == null) {
          _selectedPlants.add(p);
        }
      }
    });
    if (widget.plant != null) {
      _selectedPlants = [widget.plant!];
    }
    _fetchReminders();
  }

  bool _isFilterActive() {
    return _selectedEventTypes.length != _eventTypes.length ||
        _selectedPlants.length != _plants.length;
  }

  Future<void> _fetchReminders() async {
    final List<int> selectedEventTypeIds =
        _selectedEventTypes.map((e) => e.id).toList();
    final List<int> selectedPlantIds =
        _selectedPlants.map((p) => p.id).toList();
    widget.env.reminderRepository
        .getFiltered(selectedPlantIds, selectedEventTypeIds)
        .then((r) {
      setState(() {
        _reminders = r;
      });
    });
  }

  Future<void> _navigateToAddReminder() async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddReminderPage(widget.env),
      ),
    );

    if (shouldRefresh == true) {
      _fetchReminders();
    }
  }

  Future<void> _navigateToEditReminder(
      BuildContext context, Reminder toEdit) async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditReminderPage(widget.env, toEdit),
      ),
    );

    if (shouldRefresh == true) {
      _fetchReminders();
    }
  }

  Future<dynamic> _confirmAndDelete(BuildContext context, int eventId) {
    return QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      confirmBtnText: 'Delete',
      cancelBtnText: 'Cancel',
      title: "Delete Reminder?",
      confirmBtnColor: Colors.red,
      showCancelBtn: true,
      cancelBtnTextStyle: TextStyle(
        color: Theme.of(context).colorScheme.surfaceDim,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(.8),
      onConfirmBtnTap: () {
        widget.env.reminderRepository.delete(eventId);
        _fetchReminders();
        Navigator.of(context).pop(true);
      },
    );
  }

  void _showFilterDialog() async {
    showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (BuildContext context) {
          return ReminderFilter(
              widget.env,
              _eventTypes.values.toList(),
              _plants.values.toList(),
              _selectedEventTypes,
              _selectedPlants, (e, p) {
            setState(() {
              _selectedEventTypes = e;
              _selectedPlants = p;
            });
            _fetchReminders();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          Stack(children: [
            IconButton(
              icon: const Icon(LucideIcons.list_filter),
              onPressed: _showFilterDialog,
            ),
            if (_isFilterActive())
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inverseSurface,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ]),
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: _navigateToAddReminder,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          final reminderIcon = _eventTypes[reminder.type]!.icon;

          return GestureDetector(
            onTap: () => _navigateToEditReminder(context, reminder),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: _eventTypes[reminder.type]!.color != null
                    ? hexToColor(_eventTypes[reminder.type]!.color!)
                    : Theme.of(context).colorScheme.primary,
                child: Icon(
                  appIcons[reminderIcon],
                  color: Theme.of(context).colorScheme.surfaceDim,
                ),
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _eventTypes[reminder.type]!.name,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          _plants[reminder.plant]!.name,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              trailing: GestureDetector(
                onTap: () => _confirmAndDelete(context, reminder.id),
                child: const Icon(LucideIcons.trash_2),
              ),
            ),
          );
        },
      ),
    );
  }
}
