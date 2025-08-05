import 'package:flutter/material.dart';
import 'package:plant_it/ui/core/ui/stepper/stepper_step.dart';
import 'package:plant_it/ui/event/view_models/event_viewmodel.dart';

class DateAndNoteStep extends StepperStep {
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(true);
  final EventFormViewModel viewModel;

  DateAndNoteStep({super.key, required this.viewModel});

  @override
  State<DateAndNoteStep> createState() => _DateAndNoteStepState();

  @override
  ValueNotifier<bool> get isValidNotifier => _isValidNotifier;
}

class _DateAndNoteStepState extends State<DateAndNoteStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add last info',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: widget.viewModel.date ?? now,
              firstDate: DateTime(now.year - 5),
              lastDate: DateTime(now.year + 5),
            );
            if (selectedDate != null) {
              widget.viewModel.setDate(selectedDate);
              setState(() {});
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              labelText: "Date",
            ),
            child: Text(widget.viewModel.date?.toString().split(' ').first ??
                'Select a date'),
          ),
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: TextEditingController(text: widget.viewModel.note)
            ..selection = TextSelection.collapsed(
                offset: widget.viewModel.note?.length ?? 0),
          maxLines: 4,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Note',
          ),
          onChanged: (String note) {
            widget.viewModel.setNote(note);
          },
        ),
      ],
    );
  }
}
