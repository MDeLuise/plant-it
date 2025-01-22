class SpeciesDTO {
  final String externalId;
  final String scientificName;
  final String? author;
  final String family;
  final String genus;
  final String? imageUrl;

  SpeciesDTO({
    required this.externalId,
    required this.scientificName,
    this.author,
    required this.family,
    required this.genus,
    this.imageUrl,
  });
}