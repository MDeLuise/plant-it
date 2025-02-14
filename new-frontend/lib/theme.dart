import 'package:flutter/material.dart';

ThemeData getLightTheme(BuildContext context, Color primaryColor) {
  return ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor, //Colors.green,
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
          onSurface: const Color.fromRGBO(49, 49, 49, 1),
          shadow: const Color.fromARGB(255, 208, 208, 208),
          //onPrimary: const Color.fromARGB(255, 35, 80, 36),
        ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(
        color: Color.fromARGB(138, 158, 158, 158),
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
          side: const BorderSide(color: Colors.green, width: 2),
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.green;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(Colors.white),
        ),
    sliderTheme: Theme.of(context).sliderTheme.copyWith(
          activeTrackColor: Colors.green,
          inactiveTrackColor: Colors.green.withAlpha(200),
          thumbColor: Colors.green,
          overlayColor: Colors.green.withAlpha(200),
          trackHeight: 4.0,
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: const Color.fromRGBO(245, 245, 247, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: const Color.fromRGBO(245, 245, 247, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.green,
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
  );
}

ThemeData getDarkTheme(BuildContext context, Color primaryColor) {
  return ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor, //const Color.fromARGB(255, 52, 119, 54),
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
          onSurface: const Color.fromRGBO(217, 214, 209, 1),
          shadow: const Color.fromARGB(255, 13, 13, 13),
          onPrimary: const Color.fromARGB(255, 35, 80, 36),
        ),
    inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
      color: Color.fromRGBO(87, 86, 83, 1),
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.green,
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
  );
}
