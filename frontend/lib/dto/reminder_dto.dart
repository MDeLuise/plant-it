enum Unit { DAYS, WEEKS, MONTHS, YEARS }

class FrequencyDTO {
  int quantity;
  Unit unit;

  FrequencyDTO({
    required this.quantity,
    required this.unit,
  });

  static Unit _stringToUnit(String unitString) {
    switch (unitString.toLowerCase()) {
      case 'days':
        return Unit.DAYS;
      case 'weeks':
        return Unit.WEEKS;
      case 'months':
        return Unit.MONTHS;
      case 'years':
        return Unit.YEARS;
      default:
        throw Exception('Invalid unit string: $unitString');
    }
  }

  factory FrequencyDTO.fromJson(Map<String, dynamic> json) {
    return FrequencyDTO(
      quantity: json['quantity'],
      unit: _stringToUnit(json['unit']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "quantity": quantity,
      "unit": unit.toString().split('.').last,
    };
  }
}

class ReminderDTO {
  int? id;
  int? targetId;
  DateTime? start;
  DateTime? end;
  FrequencyDTO? frequency;
  FrequencyDTO? repeatAfter;
  DateTime? lastNotified;
  String? action;
  bool? enabled;

  ReminderDTO({
    this.id,
    this.targetId,
    this.start,
    this.end,
    this.frequency,
    this.repeatAfter,
    this.lastNotified,
    this.action,
    this.enabled,
  });

  factory ReminderDTO.fromJson(Map<String, dynamic> json) {
    return ReminderDTO(
      id: json['id'],
      targetId: json['targetId'],
      start: DateTime.parse(json['start']),
      end: json["end"] != null ? DateTime.parse(json['end']) : null,
      frequency: FrequencyDTO.fromJson(json['frequency']),
      repeatAfter: FrequencyDTO.fromJson(json['repeatAfter']),
      lastNotified: json["lastNotified"] != null
          ? DateTime.parse(json['lastNotified'])
          : null,
      action: json['action'],
      enabled: json['enabled'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    if (id != null) map['id'] = id;
    if (action != null) map['action'] = action;
    if (targetId != null) map['targetId'] = targetId;
    if (start != null) map['start'] = start!.toIso8601String();
    if (end != null) map['end'] = end!.toIso8601String();
    if (frequency != null) map['frequency'] = frequency!.toMap();
    if (repeatAfter != null) map['repeatAfter'] = repeatAfter!.toMap();
    if (lastNotified != null) map['lastNotified'] = lastNotified!.toString();
    if (enabled != null) map['enabled'] = enabled;
    return map;
  }
}
