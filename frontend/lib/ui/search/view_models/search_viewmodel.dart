import 'dart:convert';
import 'dart:typed_data';

import 'package:command_it/command_it.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:plant_it/data/repository/image_repository.dart';
import 'package:plant_it/data/service/search/species_searcher_facade.dart';
import 'package:plant_it/database/database.dart';
import 'package:plant_it/domain/models/species_searcher_result.dart';
import 'package:result_dart/result_dart.dart';

class Query {
  final String term;
  final int offset;
  final int limit;

  Query({
    required this.term,
    required this.offset,
    required this.limit,
  });
}

class SearchViewModel extends ChangeNotifier {
  final SpeciesSearcherFacade _speciesSearcherFacade;
  final ImageRepository _imageRepository;

  SearchViewModel({
    required SpeciesSearcherFacade speciesSearcherFacade,
    required ImageRepository imageRepository,
  })  : _speciesSearcherFacade = speciesSearcherFacade,
        _imageRepository = imageRepository {
    search = Command.createAsync((Query q) async {
      Result<void> result = await _query(q);
      if (result.isError()) throw result.exceptionOrNull()!;
      return;
    }, initialValue: null);
  }

  final _log = Logger('SearchViewModel');
  List<SpeciesSearcherPartialResult> _result = [];

  late final Command<Query, void> search;

  List<SpeciesSearcherPartialResult> get result => _result;

  Future<Result<void>> _query(Query query) async {
    Result<List<SpeciesSearcherPartialResult>> species =
        await _speciesSearcherFacade.search(
      query.term,
      query.offset,
      query.limit,
    );
    if (species.isError()) {
      return species;
    }
    _log.fine("Loaded queried species");
    _result = species.getOrThrow();
    notifyListeners();
    return Success("ok");
  }

  Future<Result<String>> getImageBase64(
      SpeciesSearcherPartialResult speciesSearcherResult) async {
    SpeciesCompanion species = speciesSearcherResult.speciesCompanion;
    Result<String>? base64 =
        await _imageRepository.getSpeciesImageBase64(species.id.value);
    if (base64 != null) {
      return base64;
    }
    if (species.externalAvatarUrl.present &&
        species.externalAvatarUrl.value != null) {
      String? fetchedBase64 =
          await _fetchImageAsBase64(species.externalAvatarUrl.value!);
      if (fetchedBase64.isNotEmpty) {
        return Success(fetchedBase64);
      }
    }
    return Success("");
  }

  Future<String> _fetchImageAsBase64(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;
        return base64Encode(bytes);
      } else {
        _log.severe(
            "Failed to load image from URL: $url, Status code: ${response.statusCode}");
        return "";
      }
    } catch (e) {
      _log.severe("Error fetching image from URL: $url, Error: $e");
      return "";
    }
  }
}
