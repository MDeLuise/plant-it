import 'package:flutter/material.dart';
import 'package:plant_it/l10n/generated/app_localizations.dart';

abstract class StepSection<T> extends StatefulWidget {
  final T viewModel;
  final L appLocalizations;

  const StepSection({
    super.key,
    required this.viewModel,
    required this.appLocalizations,
  });

  /// Validation notifier
  ValueNotifier<bool> get isValidNotifier;

  /// Section title
  String get title;

  /// Display value (summary or current input)
  String get value;

  /// Whether this section performs an action in summary mode
  bool get isActionSection => false;

  /// Confirms data (used for summary finalization or saving)
  void confirm();

  void cancel();

  /// Optional extra action, can be overridden
  Future<void> action(BuildContext context, T viewModel) async {
    throw UnimplementedError();
  }
}
