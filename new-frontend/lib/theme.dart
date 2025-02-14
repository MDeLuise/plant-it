import 'package:flutter/material.dart';

ThemeData getLightTheme(BuildContext context, Color primaryColor) {
  return ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    indicatorColor: primaryColor,
    dividerColor: const Color.fromARGB(255, 122, 122, 122),
    textTheme: Theme.of(context).textTheme.copyWith(
          headlineSmall: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color.fromRGBO(49, 49, 49, 1),
              ),
        ),
    colorScheme: Theme.of(context).colorScheme.copyWith(
          surface: const Color.fromRGBO(245, 245, 247, 1),
          surfaceBright: const Color.fromRGBO(245, 245, 247, 1),
          onSurface: const Color.fromRGBO(49, 49, 49, 1),
          shadow: const Color.fromARGB(255, 208, 208, 208),
        ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: Color.fromARGB(137, 127, 127, 127),
      ),
      fillColor: Color.fromRGBO(245, 245, 247, 1),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
    ),
    cardTheme: Theme.of(context).cardTheme.copyWith(
          elevation: 2,
          color: const Color.fromRGBO(245, 245, 247, 1),
          shadowColor: const Color.fromARGB(255, 208, 208, 208),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
    checkboxTheme: Theme.of(context).checkboxTheme.copyWith(
      //side: const BorderSide(color: Colors.green, width: 2),
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return Colors.transparent;
      }),
      //checkColor: WidgetStateProperty.all(Colors.white),
    ),
    sliderTheme: Theme.of(context).sliderTheme.copyWith(
          activeTrackColor: primaryColor,
          inactiveTrackColor: primaryColor.withAlpha(200),
          thumbColor: primaryColor,
          overlayColor: primaryColor.withAlpha(200),
          trackHeight: 4.0,
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: const Color.fromRGBO(245, 245, 247, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: const Color.fromRGBO(245, 245, 247, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: const Color.fromRGBO(245, 245, 247, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    floatingActionButtonTheme:
        Theme.of(context).floatingActionButtonTheme.copyWith(
              backgroundColor: Colors.green,
              foregroundColor: const Color.fromARGB(255, 35, 80, 36),
            ),
    switchTheme: Theme.of(context).switchTheme.copyWith(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return const Color.fromARGB(255, 108, 108, 108);
      }),
    ),
    textSelectionTheme: Theme.of(context).textSelectionTheme.copyWith(
          cursorColor: primaryColor,
          selectionHandleColor: primaryColor,
          selectionColor: primaryColor,
        ),
  );
}

ThemeData getDarkTheme(BuildContext context, Color primaryColor) {
  return ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    indicatorColor: primaryColor,
    textTheme: Theme.of(context).textTheme.copyWith(
          headlineSmall: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: const Color.fromRGBO(217, 214, 209, 1),
              ),
          bodyLarge: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: const Color.fromRGBO(217, 214, 209, 1),
              ),
          bodyMedium: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: const Color.fromRGBO(217, 214, 209, 1),
              ),
          bodySmall: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: const Color.fromRGBO(217, 214, 209, 1),
              ),
        ),
    colorScheme: Theme.of(context).colorScheme.copyWith(
          surface: const Color.fromARGB(255, 29, 30, 32),
          surfaceBright: const Color.fromARGB(255, 50, 52, 56),
          onSurface: const Color.fromRGBO(217, 214, 209, 1),
          shadow: const Color.fromARGB(255, 31, 31, 31),
        ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        color: Color.fromRGBO(143, 142, 141, 1),
      ),
      fillColor: const Color.fromARGB(255, 50, 52, 56),
      filled: false,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: const Color.fromRGBO(245, 245, 247, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    floatingActionButtonTheme:
        Theme.of(context).floatingActionButtonTheme.copyWith(
              backgroundColor: Colors.green,
              foregroundColor: const Color.fromARGB(255, 35, 80, 36),
            ),
    cardTheme: Theme.of(context).cardTheme.copyWith(
        color: const Color.fromARGB(255, 50, 52, 56),
        surfaceTintColor: primaryColor),
    checkboxTheme: Theme.of(context).checkboxTheme.copyWith(
      //side: const BorderSide(color: Colors.green, width: 2),
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return Colors.transparent;
      }),
      //checkColor: WidgetStateProperty.all(Colors.white),
    ),
    switchTheme: Theme.of(context).switchTheme.copyWith(
      thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return const Color.fromARGB(255, 108, 108, 108);
      }),
    ),
    textSelectionTheme: Theme.of(context).textSelectionTheme.copyWith(
          cursorColor: primaryColor,
          selectionHandleColor: primaryColor,
          selectionColor: primaryColor,
        ),
  );
}
