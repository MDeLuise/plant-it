import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

const PaintingEffect skeletonizerEffect = PulseEffect(
  from: Colors.grey,
  to: Color.fromARGB(255, 207, 207, 207),
);

Widget Function(BuildContext context, Widget? widget) datePickerTheme =
    (context, child) {
  return Theme(
    data: Theme.of(context).copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color.fromARGB(255, 94, 156, 134), // header background color
        onPrimary: Colors.white, // header text color
        onSurface: Colors.white, // body text color
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor:
              const Color.fromARGB(255, 120, 30, 136), // button text color
        ),
      ),
    ),
    child: child!,
  );
};

final ThemeData theme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF061913), // Background color

  // Text styles
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
        color: Color.fromARGB(255, 221, 220, 220)), // Default text color
    bodyLarge: TextStyle(
        color: Color.fromARGB(255, 221, 220, 220)), // Large body text color
  ),

  // Radio button style
  radioTheme: RadioThemeData( 
    fillColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.grey; // Color when radio button is disabled
        }
        return Colors.white; // Color when radio button is enabled
      },
    ),
  ),

  // Form field styles
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
        color: Colors.grey
            .withOpacity(0.7)), // Form field label color with opacity
    hintStyle:
        const TextStyle(color: Colors.grey), // Form field hint text color
    focusedBorder: const OutlineInputBorder(
      borderSide:
          BorderSide(color: Color(0xFF6DD075)), // Border color when focused
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
          color: const Color(0xFF6DD075)
              .withOpacity(0.5)), // Border color with opacity
    ),
  ),

  // Button styles
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
          const Color(0xFF6DD075)), // Button background color
      foregroundColor:
          WidgetStateProperty.all<Color>(Colors.black), // Button text color
    ),
  ),

  // AppBar styles
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent, // Make AppBar transparent
    elevation: 0, // Remove shadow
    iconTheme: IconThemeData(color: Colors.white), // Icon color
    titleTextStyle: TextStyle(color: Colors.white), // Title text color
  ),

  // FloatingActionButton styles
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromRGBO(76, 175, 80, 1),
    shape: CircleBorder(),
  ),

  // Dialog theme configuration
  dialogTheme: const DialogTheme(
    backgroundColor:
        Color.fromRGBO(24, 44, 37, 1), // Change background color for dialogs
    // Dialog theme configuration
    titleTextStyle: TextStyle(
      color: Colors.white, // Change title text color
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),

  // Other element styles
  iconTheme: const IconThemeData(color: Colors.white), // Icon color
);
