import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/ui/core/ui/error_indicator.dart';
import 'package:plant_it/ui/core/ui/multi_select.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';

class EventScreen extends StatefulWidget {
  final EventFormViewModel viewModel;

  const EventScreen({super.key, required this.viewModel});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      widget.viewModel.setDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text('Create Event'),
      ),
      body: ValueListenableBuilder<CommandResult<void, void>>(
          valueListenable: widget.viewModel.load.results,
          builder: (context, command, _) {
            if (command.hasError) {
              return ErrorIndicator(
                title:
                    "Error", // AppLocalization.of(context).errorWhileLoadingHome,
                label: "Try again", //AppLocalization.of(context).tryAgain,
                onPressed: widget.viewModel.load.execute,
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFieldMultipleDropDown<EventType>(
                    options: widget.viewModel.eventTypes,
                    text: 'Event Type',
                    onSelectedItemsChanged: widget.viewModel.setEventTypeList,
                    getLabel: (EventType et) => et.name,
                  ),
                  const SizedBox(height: 16),
                  TextFieldMultipleDropDown<Plant>(
                    options: widget.viewModel.plants,
                    text: 'Plants',
                    onSelectedItemsChanged: widget.viewModel.setPlantList,
                    getLabel: (Plant p) => p.name,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      child: Text(DateFormat.yMMMd().format(_selectedDate)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: "Note",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => widget.viewModel.setNote,
                  ),
                  const SizedBox(height: 24),
                  ValueListenableBuilder<CommandResult<void, String>>(
                      valueListenable: widget.viewModel.insert.results,
                      builder: (context, command, _) {
                        if (command.isExecuting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (command.isSuccess &&
                            command.data.toString() != "not started") {
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Events added')));
                        }
                        if (command.hasError) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Error: ${command.error?.toString() ?? 'Unknown error'}',
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ));
                          });
                        }
                        return ElevatedButton(
                          onPressed: () async {
                            widget.viewModel.insert.execute();
                          },
                          child: const Text('Save Event'),
                        );
                      }),
                ],
              ),
            );
          }),
    );
  }
}
