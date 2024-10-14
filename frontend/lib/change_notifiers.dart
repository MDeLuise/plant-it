import 'package:flutter/foundation.dart';

class EventsNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class PhotosNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}
