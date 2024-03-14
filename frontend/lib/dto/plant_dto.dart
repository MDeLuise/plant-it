class PlantDTO {
  final int? id;
  final PlantInfoDTO info;
  final int? ownerId;
  final String? avatarImageId;
  final String? avatarMode;
  final int? diaryId;
  final int? speciesId;
  final String? species;

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
  final String? startDate;
  final String personalName;
  final String? endDate;
  final String state;
  final String? note;
  final double? purchasedPrice;
  final String? currencySymbol;
  final String? seller;
  final String? location;

  PlantInfoDTO({
    this.startDate,
    required this.personalName,
    this.endDate,
    required this.state,
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
