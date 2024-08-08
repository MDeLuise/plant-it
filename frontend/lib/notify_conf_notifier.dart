import 'package:flutter/foundation.dart';

class NotifyConfNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
