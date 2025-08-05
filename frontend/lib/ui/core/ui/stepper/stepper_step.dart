import 'package:flutter/widgets.dart';

abstract class StepperStep extends StatefulWidget {
  const StepperStep({super.key});

  ValueNotifier<bool> get isValidNotifier;
}
