import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

Future navigateTo(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

Future replaceTo(BuildContext context, Widget page) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

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

String formatDate(DateTime date) {
  return DateFormat('E, dd MMM yyyy').format(date);
}

String timeDiffStr(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  final isFuture = difference.isNegative;
  final duration = isFuture ? -difference : difference;

  if (duration.inDays >= 365) {
    final years = duration.inDays ~/ 365;
    return _buildTimeString(years, 'year', isFuture);
  } else if (duration.inDays >= 30) {
    final months = duration.inDays ~/ 30;
    return _buildTimeString(months, 'month', isFuture);
  } else if (duration.inDays >= 7) {
    final weeks = duration.inDays ~/ 7;
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

Color adaptiveColor(BuildContext context, Color color) {
  final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

  if (isDarkMode) {
    return darkenColor(color, .12);
  }
  return color;
}

Color darkenColor(Color color, double factor) {
  final hsl = HSLColor.fromColor(color);
  return hsl.withLightness((hsl.lightness - factor).clamp(0.0, 1.0)).toColor();
}

enum FeedbackLevel {
  error,
  success,
  info;
}

void showSnackbar(
    BuildContext context, FeedbackLevel level, String msg, String? details) {
  toastification.show(
    context: context,
    type: level == FeedbackLevel.info
        ? ToastificationType.info
        : level == FeedbackLevel.success
            ? ToastificationType.success
            : ToastificationType.error,
    style: ToastificationStyle.flatColored,
    title: Text(msg),
    description: details != null ? Text(details) : null,
    alignment: Alignment.topCenter,
    autoCloseDuration: const Duration(seconds: 4),
    boxShadow: highModeShadow,
    pauseOnHover: false,
    closeOnClick: true,
  );
}
