import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:plant_it/data/repository/user_setting_repository.dart';
import 'package:plant_it/data/service/search/species_searcher.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:plant_it/domain/models/user_settings_keys.dart';
import 'package:result_dart/result_dart.dart';

// {
//     "id": "609e2c34ca233f0aecfa9707",
//     "author": "Schott",
//     "common_name": "Adanson's Monstera",
//     "slug": "609e2c34ca233f0aecfa9707",
//     "scientific_name": "Monstera adansonii",
//     "genus_id": "609cccffb0f222c82c6204fe",
//     "links": {
//         "self": "/api/v1/species/609e2c34ca233f0aecfa9707",
//         "genus": "/api/v1/species/609cccffb0f222c82c6204fe",
//         "plant": "/api/v1/plants/609e2c34ca233f0aecfa9707"
//     },
//     "meta": {
//         "last_modified": "2021-06-08T06:49:56.226Z"
//     },
//     "status": "ACCEPTED",
//     "rank": "SPECIES",
//     "family": "Araceae",
//     "genus": "Monstera",
//     "image_url": "https://inaturalist-open-data.s3.amazonaws.com/photos/21333744/original.jpg",
//     "specifications": {},
//     "growth": {},
//     "images": {
//         "other": [
//             {
//                 "id": "fc:609e2c34ca233f0aecfa9707:inaturalist:206267:img:21333744",
//                 "image_url": "https://inaturalist-open-data.s3.amazonaws.com/photos/21333744/original.jpg",
//                 "copyright": "Taken July 14, 2018 by deboas (CC-BY)"
//             },
//             {
//                 "id": "fc:609e2c34ca233f0aecfa9707:inaturalist:206267:img:21333768",
//                 "image_url": "https://inaturalist-open-data.s3.amazonaws.com/photos/21333768/original.jpg",
//                 "copyright": "Taken July 14, 2018 by deboas (CC-BY)"
//             },
//             {
//                 "id": "fc:609e2c34ca233f0aecfa9707:inaturalist:206267:img:21333786",
//                 "image_url": "https://inaturalist-open-data.s3.amazonaws.com/photos/21333786/original.jpg",
//                 "copyright": "Taken July 14, 2018 by deboas (CC-BY)"
//             },
//             {
//                 "id": "fc:609e2c34ca233f0aecfa9707:inaturalist:206267:img:24305021",
//                 "image_url": "https://inaturalist-open-data.s3.amazonaws.com/photos/24305021/original.jpg",
//                 "copyright": "Taken February 28, 2018 by Basílio Maciel (CC-BY-NC-SA)"
//             },
//             {
//                 "id": "fc:609e2c34ca233f0aecfa9707:inaturalist:206267:img:24305048",
//                 "image_url": "https://inaturalist-open-data.s3.amazonaws.com/photos/24305048/original.jpg",
//                 "copyright": "Taken February 28, 2018 by Basílio Maciel (CC-BY-NC-SA)"
//             }
//         ]
//     },
//     "common_names": [
//         {
//             "ENGLISH": [
//                 "Adanson's monstera"
//             ]
//         }
//     ]
// }

class FloraCodexSearcher extends SpeciesSearcher {
  final UserSettingRepository _userSettingRepository;
  final String baseUrl = "https://api.floracodex.com";
  final String version = "/v1/";
  String? _apiKey;
  bool _initialized = false;

  FloraCodexSearcher({required UserSettingRepository userSettingRepository})
      : _userSettingRepository = userSettingRepository;

  void setKey(String? key) {
    _apiKey = key;
  }

  @override
  Future<Result<List<SpeciesSearcherPartialResult>>> search(
      String term, int offset, int limit) async {
    if (!_initialized) {
      Result<void> init = await _initialize();
      if (init.isError()) {
        return Failure(Exception(init.exceptionOrNull()));
      }
    }
    if (_apiKey == null) {
      return Success([]);
    }

    final String url =
        "$baseUrl$version/species/search?q=$term&limit=$limit&page=0&key=$_apiKey";
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return Failure(Exception("Error while loading species from Flora Codex"));
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    // final Map<String, dynamic> jsonResponse = json.decode(
    //     '{"data":[{"id":"609e9179ca233f0aecfbea5e","slug":"609e9179ca233f0aecfbea5e","scientific_name":"Lithothamnium mesomorphum var. mesomorphum","status":"ACCEPTED","rank":"VARIETY","family":"Corallinaceae","genus":"Lithothamnium","genus_id":"609ccbb5b0f222c82c61f442","links":{"self":"/v1/species/609e9179ca233f0aecfbea5e","genus":"/v1/species/609ccbb5b0f222c82c61f442","plant":"/v1/plants/609e9179ca233f0aecfbea5e"},"meta":{"last_modified":"2021-06-08T01:32:14.649Z"}},{"id":"609e0608ca233f0aecfa158f","slug":"609e0608ca233f0aecfa158f","scientific_name":"Lithothamnium mesomorphum","status":"ACCEPTED","rank":"SPECIES","family":"Corallinaceae","genus":"Lithothamnium","genus_id":"609ccbb5b0f222c82c61f442","links":{"self":"/v1/species/609e0608ca233f0aecfa158f","genus":"/v1/species/609ccbb5b0f222c82c61f442","plant":"/v1/plants/609e0608ca233f0aecfa158f"},"meta":{"last_modified":"2021-06-08T01:32:14.380Z"}},{"id":"609ccbb5b0f222c82c61f441","author":"R. A. Philippi, 1837","slug":"609ccbb5b0f222c82c61f441","scientific_name":"Lithophyllum","status":"ACCEPTED","rank":"GENUS","family":"Corallinaceae","genus":"Lithophyllum","genus_id":"609ccbb5b0f222c82c61f441","links":{"self":"/v1/species/609ccbb5b0f222c82c61f441","genus":"/v1/species/609ccbb5b0f222c82c61f441","plant":"/v1/plants/609ccbb5b0f222c82c61f441"},"meta":{"last_modified":"2021-06-08T01:32:18.595Z"}},{"id":"609e0605ca233f0aecfa1586","slug":"609e0605ca233f0aecfa1586","scientific_name":"Lithothamnium aculeiferum","status":"ACCEPTED","rank":"SPECIES","family":"Corallinaceae","genus":"Lithothamnium","genus_id":"609ccbb5b0f222c82c61f442","links":{"self":"/v1/species/609e0605ca233f0aecfa1586","genus":"/v1/species/609ccbb5b0f222c82c61f442","plant":"/v1/plants/609e0605ca233f0aecfa1586"},"meta":{"last_modified":"2021-06-08T01:32:19.405Z"}},{"id":"609e0607ca233f0aecfa158d","slug":"609e0607ca233f0aecfa158d","scientific_name":"Lithothamnium corallioides","status":"ACCEPTED","rank":"SPECIES","family":"Corallinaceae","genus":"Lithothamnium","genus_id":"609ccbb5b0f222c82c61f442","links":{"self":"/v1/species/609e0607ca233f0aecfa158d","genus":"/v1/species/609ccbb5b0f222c82c61f442","plant":"/v1/plants/609e0607ca233f0aecfa158d"},"meta":{"last_modified":"2021-06-08T01:32:17.544Z"}},{"id":"609e0607ca233f0aecfa158e","slug":"609e0607ca233f0aecfa158e","scientific_name":"Lithothamnium sonderi","status":"ACCEPTED","rank":"SPECIES","family":"Corallinaceae","genus":"Lithothamnium","genus_id":"609ccbb5b0f222c82c61f442","links":{"self":"/v1/species/609e0607ca233f0aecfa158e","genus":"/v1/species/609ccbb5b0f222c82c61f442","plant":"/v1/plants/609e0607ca233f0aecfa158e"},"meta":{"last_modified":"2021-06-08T01:32:17.806Z"}},{"id":"609e0607ca233f0aecfa158c","slug":"609e0607ca233f0aecfa158c","scientific_name":"Lithothamnium volcanum","status":"ACCEPTED","rank":"SPECIES","family":"Corallinaceae","genus":"Lithothamnium","genus_id":"609ccbb5b0f222c82c61f442","links":{"self":"/v1/species/609e0607ca233f0aecfa158c","genus":"/v1/species/609ccbb5b0f222c82c61f442","plant":"/v1/plants/609e0607ca233f0aecfa158c"},"meta":{"last_modified":"2021-06-08T01:32:17.279Z"}},{"id":"609e0600ca233f0aecfa1574","slug":"609e0600ca233f0aecfa1574","scientific_name":"Lithophyllum grumosum","status":"ACCEPTED","rank":"SPECIES","family":"Corallinaceae","genus":"Lithophyllum","genus_id":"609ccbb5b0f222c82c61f441","links":{"self":"/v1/species/609e0600ca233f0aecfa1574","genus":"/v1/species/609ccbb5b0f222c82c61f441","plant":"/v1/plants/609e0600ca233f0aecfa1574"},"meta":{"last_modified":"2021-06-08T01:32:18.854Z"}},{"id":"609e0600ca233f0aecfa1575","slug":"609e0600ca233f0aecfa1575","scientific_name":"Lithophyllum imitans","status":"ACCEPTED","rank":"SPECIES","family":"Corallinaceae","genus":"Lithophyllum","genus_id":"609ccbb5b0f222c82c61f441","links":{"self":"/v1/species/609e0600ca233f0aecfa1575","genus":"/v1/species/609ccbb5b0f222c82c61f441","plant":"/v1/plants/609e0600ca233f0aecfa1575"},"meta":{"last_modified":"2021-06-08T01:32:19.134Z"}},{"id":"609e0605ca233f0aecfa1585","slug":"609e0605ca233f0aecfa1585","scientific_name":"Lithothamnium phymatodeum","status":"ACCEPTED","rank":"SPECIES","family":"Corallinaceae","genus":"Lithothamnium","genus_id":"609ccbb5b0f222c82c61f442","links":{"self":"/v1/species/609e0605ca233f0aecfa1585","genus":"/v1/species/609ccbb5b0f222c82c61f442","plant":"/v1/plants/609e0605ca233f0aecfa1585"},"meta":{"last_modified":"2021-06-08T01:32:24.485Z"}}],"self":"/v1/species/search?q=litho&limit=10&page=0&key=Dq53JhHUCt2xbXYmIgQOwncdoCnF1G6D45sHNh2JdscX-0IFhVwAhe36TKTaiuP2","first":"/v1/species/search?q=litho&limit=10&page=1&key=Dq53JhHUCt2xbXYmIgQOwncdoCnF1G6D45sHNh2JdscX-0IFhVwAhe36TKTaiuP2","next":"/v1/species/search?q=litho&limit=10&page=1&key=Dq53JhHUCt2xbXYmIgQOwncdoCnF1G6D45sHNh2JdscX-0IFhVwAhe36TKTaiuP2","last":"/v1/species/search?q=litho&limit=10&page=11&key=Dq53JhHUCt2xbXYmIgQOwncdoCnF1G6D45sHNh2JdscX-0IFhVwAhe36TKTaiuP2","meta":{"total":106}}');
    final List<dynamic> dataList = jsonResponse['data'] ?? [];
    final List<_FloraCodexSpeciesDTO> floraCodexSpeciesDTOs =
        dataList.where((e) => e['rank'] == "SPECIES").map((item) {
      return _FloraCodexSpeciesDTO.fromJson(item);
    }).toList();

    List<SpeciesSearcherPartialResult> result = [];
    for (_FloraCodexSpeciesDTO dto in floraCodexSpeciesDTOs) {
      Result<SpeciesSearcherPartialResult> species =
          await _getSpeciesSearcherResult(dto);
      if (species.isError()) {
        return Failure(Exception(species.exceptionOrNull()));
      }
      result.add(species.getOrThrow());
    }

    return Success(result);
  }

  Future<Result<SpeciesSearcherPartialResult>> _getSpeciesSearcherResult(
      _FloraCodexSpeciesDTO dto) async {
    return Success(
      SpeciesSearcherPartialResult(
        speciesCompanion: SpeciesCompanion(
          id: Value(-1),
          scientificName: Value(dto.scientificName),
          family: Value(dto.family),
          genus: Value(dto.genus),
          species: Value(dto.scientificName),
          author: Value(dto.author),
          externalAvatarUrl: Value(dto.imageUrl),
          dataSource: const Value(SpeciesDataSource.floraCodex),
          externalId: Value(dto.id),
        ),
      ),
    );
  }

  @override
  Future<Result<SpeciesSearcherResult>> getDetails(String id) async {
    Result<SpeciesCompanion> species = await _getSpecies(id);
    if (species.isError()) {
      return Failure(Exception(species.exceptionOrNull()));
    }
    Result<SpeciesCareCompanion> care = await _getCare(id);
    if (care.isError()) {
      return Failure(Exception(care.exceptionOrNull()));
    }
    Result<List<SpeciesSynonymsCompanion>> synonyms = await _getSynonyms(id);
    if (synonyms.isError()) {
      return Failure(Exception(synonyms.exceptionOrNull()));
    }

    return Success(SpeciesSearcherResult(
      speciesCompanion: species.getOrThrow(),
      speciesCareCompanion: care.getOrThrow(),
      speciesSynonymsCompanion: synonyms.getOrThrow(),
    ));
  }

  Future<Result<SpeciesCompanion>> _getSpecies(String id) async {
    String url = "$baseUrl$version/species/$id?key=$_apiKey";
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      return Failure(Exception("Error while loading species from Flora Codex"));
    }
    dynamic jsonResponse = json.decode(response.body);
    _FloraCodexSpeciesDTO dto = _FloraCodexSpeciesDTO.fromJson(jsonResponse);
    return Success(
      SpeciesCompanion(
        id: Value(-1),
        scientificName: Value(dto.scientificName),
        family: Value(dto.family),
        genus: Value(dto.genus),
        species: Value(dto.scientificName),
        author: Value(dto.author),
        externalAvatarUrl: Value(dto.imageUrl),
        dataSource: const Value(SpeciesDataSource.floraCodex),
        externalId: Value(dto.id),
      ),
    );
  }

  // always get from API the following (check better?)
  // "growth": {},
  Future<Result<SpeciesCareCompanion>> _getCare(String id) async {
    // final String url =
    //     "$baseUrl$version/plants/$id?key=$_apiKey";
    // final http.Response response = await http.get(Uri.parse(url));
    // if (response.statusCode != 200) {
    //   return Failure(
    //       Exception("Error while loading species care from Flora Codex"));
    // }
    // final Map<String, dynamic> jsonResponse = json.decode(response.body);
    return Future.value(
        const Success(SpeciesCareCompanion(species: Value(-1))));
  }

  Future<Result<List<SpeciesSynonymsCompanion>>> _getSynonyms(String id) async {
    // final String url =
    //     "$baseUrl$version/plants/$id?key=$_apiKey";
    // final http.Response response = await http.get(Uri.parse(url));

    // if (response.statusCode != 200) {
    //   Failure(Exception("Error while loading species care from Flora Codex"));
    // }
    // final Map<String, dynamic> jsonResponse = json.decode(response.body);
    //final List<String> synonyms = [];
    // final dynamic commonNames = jsonResponse['main_species']?['common_names'];

    // if (commonNames != null && commonNames is List) {
    //   for (final languageGroup in commonNames) {
    //     if (languageGroup is Map<String, dynamic>) {
    //       for (final names in languageGroup.values) {
    //         if (names is List) {
    //           synonyms.addAll(names.whereType<String>());
    //         }
    //       }
    //     }
    //   }
    // }
    return Success([]);
  }

  Future<Result<void>> _initialize() async {
    Result<String> key = await _userSettingRepository.getOrDefault(
        UserSettingsKeys.floraCodexKey.key, "");
    if (key.isError()) {
      return Failure(Exception(key.exceptionOrNull()));
    }
    if (key.getOrThrow().isNotEmpty) {
      _apiKey = key.getOrThrow();
    }
    _initialized = true;
    return Success("ok");
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
