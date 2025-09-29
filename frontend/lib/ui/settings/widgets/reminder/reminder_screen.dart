import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:go_router/go_router.dart';
import 'package:material_shapes/material_shapes.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';
import 'package:plant_it/routing/routes.dart';
import 'package:plant_it/ui/core/themes/colors.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/settings/view_models/reminder/reminder_viewmodel.dart';
import 'package:plant_it/utils/common.dart';
import 'package:plant_it/utils/icons.dart';

class ReminderScreen extends StatefulWidget {
  final ReminderViewModel viewModel;

  const ReminderScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  void remove(Reminder reminder) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(L.of(context).confirmDelete),
        content: Text(L.of(context).areYouSureYouWantToDeleteTheReminder),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(L.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              await widget.viewModel.delete.executeWithFuture(reminder.id);
              if (widget.viewModel.delete.results.value.hasError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        widget.viewModel.delete.results.value.error.toString()),
                  ),
                );
                return;
              }
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(L.of(context).reminderDeleted),
                ),
              );
              context.pop();
            },
            child: Text(L.of(context).delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.of(context).reminders),
        actions: [
          // TODO
          // IconButton(
          //   onPressed: () => context.push(Routes.eventTypes),
          //   icon: Icon(LucideIcons.filter),
          // ),
          IconButton(
            onPressed: () => context.push(Routes.reminder),
            icon: Icon(LucideIcons.plus),
          ),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<CommandResult<void, void>>(
            valueListenable: widget.viewModel.load.results,
            builder: (context, command, child) {
              if (command.isExecuting) {
                return Center(child: CircularProgressIndicator());
              }
              if (command.hasError) {
                return ErrorIndicator(
                  title:
                      L.of(context).errorWithMessage(command.error.toString()),
                  label: L.of(context).tryAgain,
                  onPressed: widget.viewModel.load.execute,
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: widget.viewModel.reminders.map((et) {
                    Plant plant = widget.viewModel.plants[et.plant]!;
                    EventType eventType = widget.viewModel.eventTypes[et.type]!;
                    return GestureDetector(
                      onTap: () => context.push(Routes.reminderWithId(et.id)),
                      child: ListTile(
                        title: Text(plant.name),
                        subtitle: Text(
                          L.of(context).reminderDescription(
                                et.frequencyQuantity,
                                et.frequencyUnit.name,
                                et.startDate,
                                et.endDate.toString(),
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: PopupMenuButton<String>(
                          padding: EdgeInsetsGeometry.all(0),
                          icon: const Icon(Icons.more_vert, size: 25),
                          onSelected: (value) {
                            if (value == 'edit') {
                              context.push(Routes.reminderWithId(et.id));
                            } else if (value == 'delete') {
                              remove(et);
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.pencil),
                                  SizedBox(width: 10),
                                  Text(L.of(context).edit),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.trash),
                                  SizedBox(width: 10),
                                  Text(L.of(context).delete),
                                ],
                              ),
                            ),
                          ],
                        ),
                        leading: Stack(
                          alignment: Alignment.center,
                          children: [
                            MaterialShapes.square(
                                size: 45, color: hexToColor(eventType.color)),
                            Icon(appIcons[eventType.icon],
                                size: 25, color: AppColors.black2),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }),
      ),
    );
  }
}
