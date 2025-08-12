import 'package:flutter/material.dart';

abstract class SummarySection<T> extends StatefulWidget {
  final T viewModel;

  const SummarySection({
    super.key,
    required this.viewModel,
  });

  ValueNotifier<bool> get isValidNotifier;
  String get title;
  String get value;
  bool get isActionSection => false;

  void confirm();
  
  Future<void> action(BuildContext context, T viewmodel) async {
    throw UnimplementedError();
  }
}
