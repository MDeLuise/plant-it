import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it/domain/models/user_settings_keys.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/ui/settings/view_models/settings_viewmodel.dart';

class NotificationsScreen extends StatelessWidget {
  final SettingsViewModel viewModel;

  const NotificationsScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(L.of(context).notifications)),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: viewModel.save.results,
          builder: (context, value, child) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(L.of(context).enableNotifications),
                    value: viewModel
                            .get(UserSettingsKeys.notificationEnabled.key) ==
                        "true",
                    onChanged: (bool value) {
                      viewModel.save.execute({
                        UserSettingsKeys.notificationEnabled.key:
                            value ? "true" : "false"
                      });
                    },
                  ),
                  ListTile(
                    title: Text(L.of(context).selectWeekdaysAndTimes),
                    trailing: const Icon(Icons.arrow_forward),
                    enabled: viewModel
                            .get(UserSettingsKeys.notificationEnabled.key) ==
                        "true",
                    onTap: () async {
                      await _showWeekdayTimeSelector(context);
                    },
                  ),
                  ListTile(
                    title: Text(L.of(context).showNextNotificationsDateTime),
                    trailing: const Icon(Icons.arrow_forward),
                    enabled: viewModel
                            .get(UserSettingsKeys.notificationEnabled.key) ==
                        "true",
                    onTap: () {
                      _showNextNotificationDateTime(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showWeekdayTimeSelector(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return _WeekdayTimeSelector(viewModel: viewModel);
      },
    );

    await viewModel.load.executeWithFuture();
  }

  void _showNextNotificationDateTime(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: viewModel.notificationDateTimeDays.map((s) {
                return Text(s ?? "");
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(L.of(context).ok),
              ),
            ],
          );
        });
  }
}

class _WeekdayTimeSelector extends StatefulWidget {
  final SettingsViewModel viewModel;

  const _WeekdayTimeSelector({required this.viewModel});

  @override
  State<_WeekdayTimeSelector> createState() => _WeekdayTimeSelectorState();
}

class _WeekdayTimeSelectorState extends State<_WeekdayTimeSelector> {
  final List<String> daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  late final List<bool> selectedDays;
  late final List<TimeOfDay?> selectedTimes;

  @override
  void initState() {
    super.initState();
    selectedDays = widget.viewModel.notificationSelectedDays;
    selectedTimes = widget.viewModel.notificationTimeDays;
  }

  void _selectTime(int index) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTimes[index] ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTimes[index] = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(L.of(context).selectWeekdaysAndTimes),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: List.generate(daysOfWeek.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDays[index] = !selectedDays[index];
                      selectedTimes[index] = TimeOfDay.now();
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: selectedDays[index]
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                        child: Text(daysOfWeek[index]),
                      ),
                      TextButton(
                        onPressed: selectedDays[index]
                            ? () => _selectTime(index)
                            : null,
                        child: Text(selectedTimes[index]?.format(context) ??
                            L.of(context).pickTime),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text(L.of(context).cancel),
        ),
        TextButton(
          onPressed: () async {
            await widget.viewModel.removeAllNotificationTime
                .executeWithFuture();
            for (int i = 0; i < 7; i++) {
              if (!selectedDays[i]) {
                continue;
              }
              await widget.viewModel.saveNotificationTime.executeWithFuture({
                "minute": selectedTimes[i]!.minute,
                "hour": selectedTimes[i]!.hour,
                "weekDay": i,
              });
            }
            context.pop();
          },
          child: Text(L.of(context).done),
        ),
      ],
    );
  }
}
