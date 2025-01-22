import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/search/species_fetcher.dart';
import 'package:http/http.dart' as http;

class FloraCodexFetcher extends SpeciesFetcher {
  final String apiKey;
  final String baseUrl = "https://api.floracodex.com";
  final String version = "/v1/";

  FloraCodexFetcher(this.apiKey);

  @override
  Future<List<SpeciesCompanion>> fetch(
      String partialScientificName, Pageable pageable) async {
    final String url =
        "$baseUrl$version/species/search?q=$partialScientificName&limit=${pageable.limit}&page=${pageable.pageNo}&key=$apiKey";
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("Error while loading species from Flora Codex");
    }
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List<dynamic> dataList = jsonResponse['data'] ?? [];
    final List<_FloraCodexSpeciesDTO> floraCodexSpeciesDTOs =
        dataList.where((e) => e['rank'] == "SPECIES").map((item) {
      return _FloraCodexSpeciesDTO.fromJson(item);
    }).toList();

    final List<SpeciesCompanion> result = [];
    for (_FloraCodexSpeciesDTO speciesDTO in floraCodexSpeciesDTOs) {
      result.add(await _fillPlantInfoAndReturnSpecies(speciesDTO));
    }
    return Future.value(result);
  }

  Future<SpeciesCompanion> _fillPlantInfoAndReturnSpecies(
      _FloraCodexSpeciesDTO speciesDTO) async {
    final SpeciesCompanion result = SpeciesCompanion(
      scientificName: Value(speciesDTO.scientificName),
      family: Value(speciesDTO.family),
      genus: Value(speciesDTO.genus),
      species: Value(speciesDTO.scientificName),
      author: Value(speciesDTO.author),
      avatarUrl: Value(speciesDTO.imageUrl),
    );

    // final http.Response response =
    //     await http.get(Uri.parse("$baseUrl${speciesDTO.plantUrl}?key=$apiKey"));
    // if (response.statusCode != 200) {
    //   throw Exception("Error while loading species from Flora Codex");
    // }
    // final Map<String, dynamic> jsonResponse = json.decode(response.body);

    return Future.value(result);
  }
}

class _FloraCodexSpeciesDTO {
  final String id;
  final String scientificName;
  final String? author;
  final String family;
  final String genus;
  final String? imageUrl;
  final String plantUrl;
  final String genusUrl;

  _FloraCodexSpeciesDTO({
    required this.id,
    required this.scientificName,
    this.author,
    required this.family,
    required this.genus,
    this.imageUrl,
    required this.plantUrl,
    required this.genusUrl,
  });

  factory _FloraCodexSpeciesDTO.fromJson(Map<String, dynamic> json) {
    final links = json['links'] as Map<String, dynamic>? ?? {};
    return _FloraCodexSpeciesDTO(
      id: json['id'],
      scientificName: json['scientific_name'],
      author: json['author'],
      family: json['family'],
      genus: json['genus'],
      imageUrl: json['image_url'],
      plantUrl: links['plant'] ?? '',
      genusUrl: links['genus'] ?? '',
    );
  }
}
