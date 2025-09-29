import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:intl/intl.dart';
import 'package:plant_it/ui/calendar/view_models/calendar_viewmodel.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool isFilterActive;
  final CalendarViewModel viewModel;
  final VoidCallback goToFilter;

  const CalendarHeader({
    super.key,
    required this.month,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.isFilterActive,
    required this.viewModel,
    required this.goToFilter,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedMonth = DateFormat('MMMM yyyy').format(month);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPreviousMonth,
          icon: Icon(
            LucideIcons.chevron_left,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          formattedMonth,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        IconButton(
          onPressed: onNextMonth,
          icon: Icon(
            LucideIcons.chevron_right,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Stack(
          children: [
            IconButton(
              onPressed: goToFilter,
              icon: Icon(
                LucideIcons.filter,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (isFilterActive)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
