import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:plant_it/events.dart';

class EventsNotifier extends ChangeNotifier {
  final List<EventCard> _events = [];

  UnmodifiableListView<EventCard> get recent =>
      UnmodifiableListView(_events.getRange(0, min(_events.length, 5)));

  void add(EventCard item) {
    _events.add(item);
    notifyListeners();
  }

  void addAll(List<EventCard> items) {
    _events.addAll(items);
  }

  void remove(int id) {
    _events.removeWhere((e) => e.eventDTO.id == id);
    notifyListeners();
  }

  void removeAll() {
    _events.clear();
    notifyListeners();
  }
}
