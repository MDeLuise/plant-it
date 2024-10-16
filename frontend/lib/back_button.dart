import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 65, 65, 65).withOpacity(0.2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 24.0,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
