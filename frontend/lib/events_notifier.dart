import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:plant_it/events.dart';

class EventsNotifier extends ChangeNotifier {
  final List<EventCard> _events = [];

  UnmodifiableListView<EventCard> get recent =>
      UnmodifiableListView(_events.sublist(0, min(_events.length, 5)));

  UnmodifiableListView<EventCard> getEventPage(int pageNo, int pageSize) {
    final startIndex = pageNo * pageSize;
    final endIndex = min(startIndex + pageSize, _events.length);
    final pageEvents = _events.sublist(startIndex, endIndex);
    return UnmodifiableListView(pageEvents);
  }

  void add(EventCard item) {
    _events.add(item);
    notifyListeners();
  }

  void addAll(List<EventCard> items) {
    _events.addAll(items);
    notifyListeners();
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
