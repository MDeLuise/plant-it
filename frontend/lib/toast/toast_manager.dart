import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum ToastNotificationType { info, warning, success, error }

abstract class ToastManager {
  void showToast(BuildContext context, ToastNotificationType type, String msg);
}

class ToastificationToastManager implements ToastManager {
  String _getSnackbarTitle(BuildContext context, ToastNotificationType type) {
    if (type == ToastNotificationType.success) {
      return AppLocalizations.of(context).success;
    } else if (type == ToastNotificationType.warning) {
      return AppLocalizations.of(context).warning;
    } else {
      return AppLocalizations.of(context).ops;
    }
  }

  ToastificationType _convertType(ToastNotificationType type) {
    if (type == ToastNotificationType.success) {
      return ToastificationType.success;
    } else if (type == ToastNotificationType.warning) {
      return ToastificationType.warning;
    } else {
      return ToastificationType.error;
    }
  }

  @override
  void showToast(BuildContext context, ToastNotificationType type, String msg) {
    toastification.show(
      context: context,
      type: _convertType(type),
      style: ToastificationStyle.fillColored,
      title: Text(_getSnackbarTitle(context, type)),
      icon: const Icon(Icons.check),
      description: Text(msg),
      alignment: Alignment.topCenter,
      autoCloseDuration:
          Duration(seconds: type == ToastNotificationType.success ? 3 : 5),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      applyBlurEffect: false,
      showProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
    );
  }
}
