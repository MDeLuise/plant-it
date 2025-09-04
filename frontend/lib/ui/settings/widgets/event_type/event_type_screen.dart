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
import 'package:plant_it/ui/settings/view_models/event_type/event_type_viewmodel.dart';
import 'package:plant_it/utils/common.dart';
import 'package:plant_it/utils/icons.dart';

class EventTypeScreen extends StatefulWidget {
  final EventTypeViewModel viewModel;

  const EventTypeScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<EventTypeScreen> createState() => _EventTypeScreenState();
}

class _EventTypeScreenState extends State<EventTypeScreen> {
  void removeEventType(EventType eventType) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(L.of(context).confirmDelete),
        content: Text(L
            .of(context)
            .areYouSureYouWantToDeleteTheEventTypeAndAllLinkedEvents),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(L.of(context).cancel),
          ),
          TextButton(
            onPressed: () async {
              await widget.viewModel.delete.executeWithFuture(eventType.id);
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
                  content: Text(L.of(context).eventTypeDeleted),
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
        title: Text(L.of(context).eventTypes),
        actions: [
          IconButton(
            onPressed: () => context.push(Routes.eventType),
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
                  children: widget.viewModel.eventTypes.map((et) {
                    return GestureDetector(
                      onTap: () => context.push(Routes.eventTypeWithId(et.id)),
                      child: ListTile(
                        title: Text(et.name),
                        subtitle: Text(et.description ?? "No description"),
                        trailing: PopupMenuButton<String>(
                          padding: EdgeInsetsGeometry.all(0),
                          icon: const Icon(Icons.more_vert, size: 25),
                          onSelected: (value) {
                            if (value == 'edit') {
                              context.push(Routes.eventTypeWithId(et.id));
                            } else if (value == 'delete') {
                              removeEventType(et);
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
                            MaterialShapes.circle(
                                size: 45, color: hexToColor(et.color)),
                            Icon(appIcons[et.icon],
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
