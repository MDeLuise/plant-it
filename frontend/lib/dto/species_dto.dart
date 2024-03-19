import 'dart:typed_data';

class SpeciesDTO {
  int? id;
  String scientificName;
  List<String>? synonyms;
  String? family;
  String? genus;
  String? species;
  SpeciesCareInfoDTO care;
  String? imageId;
  String? imageUrl;
  Uint8List? imageContent;
  String? imageContentType;
  String creator;
  String? externalId;

  SpeciesDTO({
    this.id,
    required this.scientificName,
    this.synonyms,
    this.family,
    this.genus,
    this.species,
    required this.care,
    this.imageId,
    this.imageUrl,
    this.imageContent,
    this.imageContentType,
    required this.creator,
    this.externalId,
  });

  factory SpeciesDTO.fromJson(Map<String, dynamic> json) {
    return SpeciesDTO(
      id: json['id'],
      scientificName: json['scientificName'],
      synonyms: json['synonyms'].toString().split(","),
      family: json['family'],
      genus: json['genus'],
      species: json['species'],
      care: SpeciesCareInfoDTO.fromJson(json['plantCareInfo']),
      imageId: json['imageId'],
      imageUrl: json['imageUrl'],
      imageContent: json['imageContent'],
      imageContentType: json['imageContentType'],
      creator: json['creator'],
      externalId: json['externalId'],
    );
  }
}

class SpeciesCareInfoDTO {
  int? light;
  int? humidity;
  double? minTemp;
  double? maxTemp;
  double? phMin;
  double? phMax;
  bool? allNull;

  SpeciesCareInfoDTO({
    this.light,
    this.humidity,
    this.minTemp,
    this.maxTemp,
    this.phMin,
    this.phMax,
    this.allNull,
  });

  factory SpeciesCareInfoDTO.fromJson(Map<String, dynamic> json) {
    return SpeciesCareInfoDTO(
      light: json['light'],
      humidity: json['humidity'],
      minTemp: json['minTemp'],
      maxTemp: json['maxTemp'],
      phMin: json['phMin'],
      phMax: json['phMax'],
      allNull: json['allNull'],
    );
  }
}
