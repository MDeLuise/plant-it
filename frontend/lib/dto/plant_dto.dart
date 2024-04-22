class PlantDTO {
  int? id;
  PlantInfoDTO info;
  int? ownerId;
  String? avatarImageId;
  String? avatarMode;
  int? diaryId;
  int? speciesId;
  String? species;

  PlantDTO({
    this.id,
    required this.info,
    this.ownerId,
    this.avatarImageId,
    this.avatarMode,
    this.diaryId,
    this.speciesId,
    this.species,
  });

  factory PlantDTO.fromJson(Map<String, dynamic> json) {
    return PlantDTO(
      id: json['id'],
      info: PlantInfoDTO.fromJson(json['info']),
      ownerId: json['ownerId'],
      avatarImageId: json['avatarImageId'],
      avatarMode: json['avatarMode'],
      diaryId: json['diaryId'],
      speciesId: json['botanicalInfoId'],
      species: json['botanicalInfoSpecies'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'info': info.toMap(),
      if (ownerId != null) 'ownerId': ownerId,
      if (avatarImageId != null) 'avatarImageId': avatarImageId,
      if (avatarMode != null) 'avatarMode': avatarMode,
      if (diaryId != null) 'diaryId': diaryId,
      if (speciesId != null) 'botanicalInfoId': speciesId,
      if (species != null) 'botanicalInfoName': species,
    };
  }
}

class PlantInfoDTO {
  String? startDate;
  String? personalName;
  String? endDate;
  String? state;
  String? note;
  double? purchasedPrice;
  String? currencySymbol;
  String? seller;
  String? location;

  PlantInfoDTO({
    this.startDate,
    this.personalName,
    this.endDate,
    this.state,
    this.note,
    this.purchasedPrice,
    this.currencySymbol,
    this.seller,
    this.location,
  });

  factory PlantInfoDTO.fromJson(Map<String, dynamic> json) {
    return PlantInfoDTO(
      startDate: json['startDate'],
      personalName: json['personalName'],
      endDate: json['endDate'],
      state: json['state'],
      note: json['note'],
      purchasedPrice: json['purchasedPrice'],
      currencySymbol: json['currencySymbol'],
      seller: json['seller'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (startDate != null) 'startDate': startDate,
      if (personalName != null) 'personalName': personalName,
      if (endDate != null) 'endDate': endDate,
      if (state != null) 'state': state,
      if (note != null) 'note': note,
      if (purchasedPrice != null) 'purchasedPrice': purchasedPrice,
      if (currencySymbol != null) 'currencySymbol': currencySymbol,
      if (seller != null) 'seller': seller,
      if (location != null) 'location': location,
    };
  }
}
