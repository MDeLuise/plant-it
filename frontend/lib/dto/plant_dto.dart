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
}
