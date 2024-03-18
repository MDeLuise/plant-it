class EventDTO {
  int? id;
  String type;
  String? note;
  DateTime date;
  int diaryId;
  int? plantId;
  String? plantName;

  EventDTO({
    this.id,
    required this.type,
    this.note,
    required this.date,
    required this.diaryId,
    this.plantId,
    this.plantName,
  });

  factory EventDTO.fromJson(Map<String, dynamic> json) {
    return EventDTO(
      id: json['id'],
      type: json['type'],
      note: json['note'],
      date: DateTime.parse(json['avatarImageId']),
      diaryId: json['diaryId'],
      plantId: json['diaryTargetId'],
      plantName: json['diaryTargetInfoPersonalName'],
    );
  }

  Map<String, String> toMap() {
    final Map<String, String> map = {
      'type': type,
      'date': date.toIso8601String(),
      'diaryId': diaryId.toString(),
    };
    if (id != null) {
      map['id'] = id.toString();
    }
    if (note != null) {
      map['note'] = note!;
    }
    if (plantId != null) {
      map['plantId'] = diaryId.toString();
    }
    if (plantName != null) {
      map['plantName'] = plantName!;
    }
    return map;
  }
}
