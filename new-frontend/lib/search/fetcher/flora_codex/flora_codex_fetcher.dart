import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/search/fetcher/species_fetcher.dart';
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

    final List<SpeciesCompanion> result = floraCodexSpeciesDTOs.map((e) {
      return SpeciesCompanion(
        scientificName: Value(e.scientificName),
        family: Value(e.family),
        genus: Value(e.genus),
        species: Value(e.scientificName),
        author: Value(e.author),
        externalAvatarUrl: Value(e.imageUrl),
        dataSource: const Value(SpeciesDataSource.floraCodex),
        externalId: Value(e.id),

      );
    }).toList();
    return Future.value(result);
  }

  @override
  Future<List<SpeciesCompanion>> fetchAll(Pageable pageable) {
    return fetch("*", pageable);
  }

  @override
  SpeciesDataSource getSpeciesDataSource() {
    return SpeciesDataSource.floraCodex;
  }

  @override
  Future<SpeciesCareCompanion> getCare(
      SpeciesCompanion speciesCompanion) async {
    final String url =
        "$baseUrl$version/plants/${speciesCompanion.externalId}?key=$apiKey";
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception("Error while loading species care from Flora Codex");
    }
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    return Future.value(const SpeciesCareCompanion());
  }

  @override
  Future<List<String>> getSynonyms(SpeciesCompanion speciesCompanion) async {
    final String url =
        "$baseUrl$version/plants/${speciesCompanion.externalId}?key=$apiKey";
    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception("Error while loading species care from Flora Codex");
    }
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    final List<String> synonyms = [];
    final dynamic commonNames = jsonResponse['main_species']?['common_names'];

    if (commonNames != null && commonNames is List) {
      for (final languageGroup in commonNames) {
        if (languageGroup is Map<String, dynamic>) {
          for (final names in languageGroup.values) {
            if (names is List) {
              synonyms.addAll(names.whereType<String>());
            }
          }
        }
      }
    }
    return synonyms;
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
