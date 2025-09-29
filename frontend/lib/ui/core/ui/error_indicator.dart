import 'package:flutter/material.dart';

import '../themes/colors.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    super.key,
    required this.title,
    required this.label,
    required this.onPressed,
  });

  final String title;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IntrinsicWidth(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: onPressed,
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.red1),
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          child: Text(label),
        ),
      ],
    );
  }
}
