import 'package:flutter/material.dart';

class InfoWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(
            icon,
            size: 30,
          ),
          const SizedBox(width: 20),
          Expanded(
            // just to make the 2 TextOverflow.ellipsis work
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
