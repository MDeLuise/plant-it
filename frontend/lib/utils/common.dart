import 'package:flutter/material.dart';

String colorToHex(Color color) {
  return "#${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}";
}

Color hexToColor(String hexString) {
  hexString = hexString.replaceAll('#', '');
  if (hexString.length == 6) {
    hexString = 'FF$hexString';
  }
  return Color(int.parse('0x$hexString'));
}

String timeDiffStr(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  bool isFuture = difference.isNegative;
  Duration duration = isFuture ? -difference : difference;

  if (duration.inDays >= 365) {
    int years = duration.inDays ~/ 365;
    return _buildTimeString(years, 'year', isFuture);
  } else if (duration.inDays >= 30) {
    int months = duration.inDays ~/ 30;
    return _buildTimeString(months, 'month', isFuture);
  } else if (duration.inDays >= 7) {
    int weeks = duration.inDays ~/ 7;
    return _buildTimeString(weeks, 'week', isFuture);
  } else if (duration.inDays >= 1) {
    return _buildTimeString(duration.inDays, 'day', isFuture);
  } else {
    if (now.day == dateTime.day) {
      return 'Today';
    } else {
      return difference.isNegative ? "Tomorrow" : "Yesterday";
    }
  }
}

String _buildTimeString(int value, String unit, bool isFuture) {
  String timeUnit = value == 1 ? unit : '$unit' 's';
  if (isFuture) {
    return 'in $value $timeUnit';
  } else {
    return '$value $timeUnit ago';
  }
}
