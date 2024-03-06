import 'package:flutter/material.dart';

final ThemeData theme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF061913), // Background color

  // Text styles
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
        color: Color.fromARGB(255, 221, 220, 220)), // Default text color
    bodyLarge: TextStyle(
        color: Color.fromARGB(255, 221, 220, 220)), // Large body text color
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
      backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xFF6DD075)), // Button background color
      foregroundColor:
          MaterialStateProperty.all<Color>(Colors.black), // Button text color
    ),
  ),

  // AppBar styles
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent, // Make AppBar transparent
    elevation: 0, // Remove shadow
    iconTheme: IconThemeData(color: Colors.white), // Icon color
    titleTextStyle: TextStyle(color: Colors.white), // Title text color
  ),

  // Other element styles
  iconTheme: const IconThemeData(color: Colors.white), // Icon color
);
